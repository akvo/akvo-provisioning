from fabric.api import local, run, env, cd, prefix, sudo, settings, put
from fabric.config import files


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
    # Note that it won't recover if the user exists but the group does not
    # or vice-versa.
    user_exists = 'id -u puppet >/dev/null 2>&1'
    create_user = 'useradd --no-user-group --create-home --shell=/bin/bash --home=/puppet/ puppet'
    sudo('%s || %s' % (user_exists, create_user))

    group_exists = 'grep -ie "^puppet" /etc/group >/dev/null 2>&1'
    setup_group = '{ addgroup puppet; useradd puppet puppet; }'
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
    sudo('apt-get update')
    sudo('apt-get install -y puppet')


def install_git():
    sudo('apt-get install -y git')


def install_modules():
    """
    Adds additional puppet modules required by the core puppet configuration.
    """
    with settings(warn_only=True):
        sudo('puppet module install puppetlabs/stdlib')
        #sudo('puppet module install puppetlabs-postgresql')
        #sudo('puppet module install puppetlabs-rabbitmq')


def firstclone():
    """
    Clones the puppet repository for the first time, which has the side-effect of
    creating the relevant repositories and validating that the keys work
    """
    with cd('/puppet'):
        if not files.exists('/puppet/checkout'):
           sudo('git clone git@github.com:akvo/akvo-provisioning.git checkout', user='puppet')


def apt_update():
    sudo('apt-get update')


def set_facts(**kwargs):
    sudo('mkdir -p /etc/facter/facts.d')
    for fact_name, fact_value in kwargs.iteritems():
        sudo('echo %s=%s >> /etc/facter/facts.d/akvo.txt' % (fact_name, fact_value))


def bootstrap(environment_type):
    create_puppet_user()
    setup_keys()

    add_puppet_repo()
    update_puppet_version()
    install_modules()

    install_git()
    firstclone()

    set_facts(environment=environment_type)


def update():
    with cd('/puppet/puppet'):
        run('hg pull -u')
        
def apply():
    sudo('puppet apply --modulepath=/etc/puppet/modules:/usr/share/puppet/modules:/puppet/puppet/modules -v /puppet/puppet/manifests/site.pp')
