from fabric.api import local, run, env, cd, prefix, sudo, settings, put
from fabric.contrib import files

# roles
import time


def management():
    env.role = 'management'


# environments
def localdev():
    env.environment = 'localdev'
def opstest():
    env.environment = 'opstest'


# commands
def echo_test():
    sudo('echo test')


def create_puppet_user():
    """
    Creates the puppet user, group and home directory.
    """
    # The first part:
    #   id -u vagrant 2>&1 >/dev/null
    # will give an exit status of 0 if the user exists, and non-0 if the
    # puppet user does not exist
    #
    # When combined with the ||, this basically means "add the puppet
    # user if it doesn't already exist", and therefore allows you to run
    # this command more than once without damaging anything.
    #
    # Similar behaviour exists for the puppet group
    user_exists = 'id -u puppet >/dev/null 2>&1'
    create_user = 'useradd --no-user-group --create-home --shell=/bin/bash --home=/puppet/ puppet'
    sudo('%s || %s' % (user_exists, create_user))

    group_exists = 'grep -ie "^puppet" /etc/group >/dev/null 2>&1'
    setup_group = '{ addgroup puppet; adduser puppet puppet; }'
    sudo('%s || %s' % (group_exists, setup_group))


def setup_keys():
    """
    Copies the puppet key for the puppet user, which grants access to the puppet
    repository on GitHub as well as allows login from the management machines to
    execute puppet updates
    """
    sudo('mkdir -p /puppet/.ssh')
    put('github_ssh_host', '/puppet/.ssh/known_hosts', use_sudo=True)
    put('puppet.id_rsa.pub', '/puppet/.ssh/id_rsa.pub', use_sudo=True)
    put('puppet.id_rsa', '/puppet/.ssh/id_rsa', use_sudo=True)
    # fix permissions
    sudo('chown -R puppet.puppet /puppet')
    sudo('chown 644 /puppet/.ssh/id_rsa.pub')
    sudo('chown 600 /puppet/.ssh/id_rsa')



def add_puppet_repo():
    """
    Adds the puppet apt repository. The version of puppet in the default Ubuntu 12.04 repositories
    is puppet 2.7.x, but we want to use puppet 3+
    """
    sudo('echo -e "deb http://apt.puppetlabs.com/ precise main\ndeb-src http://apt.puppetlabs.com/ precise main" >> /etc/apt/sources.list')
    sudo('apt-key adv --keyserver keyserver.ubuntu.com --recv 4BD6EC30')


def update_puppet_version():
    """
    Upgrades the installed version of puppet
    """
    sudo('apt-get update -q')
    sudo('apt-get install -y -q puppet')


def install_git():
    sudo('apt-get install -y -q git')


def install_modules():
    """
    Adds additional puppet modules required by the core puppet configuration.
    """
    with settings(warn_only=True):
        sudo('puppet module install puppetlabs/stdlib')
        # the puppetdb terminus is a special case, see
        # http://docs.puppetlabs.com/puppetdb/1.1/connect_puppet_apply.html
        sudo('apt-get install -q -y puppetdb-terminus')


def firstclone():
    """
    Clones the puppet repository for the first time, which has the side-effect of
    creating the relevant repositories and validating that the keys work
    """
    with cd('/puppet'):
        if not files.exists('/puppet/checkout'):
            sudo('git clone git@github.com:akvo/akvo-provisioning.git checkout', user='puppet')
            sudo('chown -R puppet.puppet /puppet/checkout')


def set_facts():
    sudo('mkdir -p /etc/facter/facts.d')
    sudo('echo environment=%s >  /etc/facter/facts.d/akvo.txt' % env.environment)
    sudo('echo role=%s        >> /etc/facter/facts.d/akvo.txt' % env.role)


def include_apply_script():
    sudo('mkdir -p /puppet/bin/')
    put('apply.sh', '/puppet/bin/apply.sh', use_sudo=True)
    sudo('chown -R puppet.puppet /puppet/bin/')
    sudo('chmod 700 /puppet/bin/apply.sh')


def apply_puppet():
    sudo('/puppet/bin/apply.sh')


def bootstrap():
    create_puppet_user()
    setup_keys()

    add_puppet_repo()
    update_puppet_version()
    install_modules()

    install_git()
    firstclone()

    set_facts()

    include_apply_script()
    apply_puppet()
    # note: we do this twice the first time - the initial setup will also configure
    # puppetdb, and the second time will reconfigure using any information read from
    # puppetdb
    # note: this needs to wait for the puppetdb server to be actually responsive
    time.sleep(10)
    apply_puppet()

