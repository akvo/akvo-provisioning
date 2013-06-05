from fabric.api import local, run, env, cd, prefix, sudo, settings, put
from fabric.contrib import files
import re
import time



# environments
def localdev():
    env.environment = 'localdev'
    env.puppetdb_url = 'puppetdb.localdev.akvo.org'
def opstest():
    env.environment = 'opstest'
    env.puppetdb_url = 'puppetdb.opstest.akvo.org'
def carltest():
    env.environment = 'carltest'
    env.puppetdb_url = 'puppetdb.akvotest.carlcrowder.com'
def live():
    env.environment = 'live'
    env.puppetdb_url = 'puppetdb.live.akvo.org'



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
    put('files/github_ssh_host', '/puppet/.ssh/known_hosts', use_sudo=True)
    put('files/puppet.id_rsa.pub', '/puppet/.ssh/id_rsa.pub', use_sudo=True)
    put('files/puppet.id_rsa', '/puppet/.ssh/id_rsa', use_sudo=True)
    # fix permissions
    sudo('chown -R puppet.puppet /puppet')
    sudo('chown 644 /puppet/.ssh/id_rsa.pub')
    sudo('chown 600 /puppet/.ssh/id_rsa')



def add_puppet_repo():
    """
    Adds the puppet apt repository. The version of puppet in the default Ubuntu 12.04 repositories
    is puppet 2.7.x, but we want to use puppet 3+
    """
    # Note: as of release 3.2.1, the following method no longer works:
    #
    # sudo('echo -e "deb http://apt.puppetlabs.com/ precise main\ndeb-src http://apt.puppetlabs.com/ precise main" >> /etc/apt/sources.list')
    # sudo('apt-key adv --keyserver keyserver.ubuntu.com --recv 4BD6EC30')
    #
    # see this discussion for why:
    #    https://groups.google.com/forum/?fromgroups#!topic/puppet-users/FFlohAZDcBk
    # and also here:
    #    http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html#for-debian-and-ubuntu

    sudo('wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb')
    sudo('sudo dpkg -i puppetlabs-release-precise.deb')
    sudo('rm puppetlabs-release-precise.deb')

def update_puppet_version():
    """
    Upgrades the installed version of puppet
    """
    flags = '-q' if env.verbose else '-qq'
    sudo('apt-get update %s' % flags)
    sudo('apt-get install -y %s puppet' % flags)


def install_git():
    flags = '-q' if env.verbose else '-qq'
    sudo('apt-get install -y %s git' % flags)


def install_modules():
    """
    Adds additional puppet modules required by the core puppet configuration.
    """
    with settings(warn_only=True):
        install_puppet_module('puppetlabs/stdlib')
        install_puppet_module('puppetlabs-postgresql')
        install_puppet_module('puppetlabs-mysql')

    # the puppetdb terminus is a special case, see
    # http://docs.puppetlabs.com/puppetdb/1.1/connect_puppet_apply.html
    flags = '-q' if env.verbose else '-qq'
    sudo('apt-get install -y %s puppetdb-terminus' % flags)


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


def include_apply_script():
    sudo('mkdir -p /puppet/bin/')
    put('files/apply.sh', '/puppet/bin/apply.sh', use_sudo=True)
    sudo('chown -R puppet.puppet /puppet/bin/')
    sudo('chmod 700 /puppet/bin/apply.sh')


def setup_hiera():
    sudo('mkdir -p /puppet/hiera/')
    sudo('chown -R puppet.puppet /puppet/hiera')
    put('files/hiera.yaml', '/etc/puppet/hiera.yaml', use_sudo=True)
    sudo('touch /puppet/hiera/nodespecific.yaml')
    relink_hiera()
    hiera_add_external_ip()


def hiera_add_external_ip():
    links = sudo("ip -o link | sed 's/[0-9]\+:\s\+//' | sed 's/:.*$//' | grep eth")
    links = links.split('\n')
    external_ip_addr = None
    internal_ip_addr = None

    # search for the first non-local ip
    for link in links:
        link = link.strip()
        ip_addr = sudo("ifconfig %s | grep 'inet addr' | awk -F: '{print $2}' | awk '{print $1}'" % link)
        if ip_addr.startswith('10.') or ip_addr.startswith('172.16.'):
            internal_ip_addr = ip_addr
        elif ip_addr.startswith('192.168.'):
            internal_ip_addr = ip_addr
            # we use the 'internal' IP for 'external' too when running on a vagrant box
            # as all services must be pointing to the local IP
            if env.environment == 'localdev':
                external_ip_addr = ip_addr
        else:
            external_ip_addr = ip_addr

    if external_ip_addr is None:
        # if we can't find one on our own interfaces, try an external tool
        external_ip_addr = sudo('wget http://ipecho.net/plain -O - -q').strip()

    sudo("sed -i '/external_ip/d' /puppet/hiera/nodespecific.yaml")
    sudo("sed -i '/internal_ip/d' /puppet/hiera/nodespecific.yaml")
    sudo('echo "external_ip : %s" >> /puppet/hiera/nodespecific.yaml' % external_ip_addr)
    sudo('echo "internal_ip : %s" >> /puppet/hiera/nodespecific.yaml' % internal_ip_addr)


def relink_hiera():
    sudo('find /puppet/hiera/ -type l -delete')
    sudo('ln -s /puppet/checkout/hiera/* /puppet/hiera/')


def get_latest_config():
    if env.environment == 'localdev':
        print "Refusing to pull puppet, as this is a vagrant box and the checkout is linked to your host machine"
        return
    with cd('/puppet/checkout'):
        sudo('git pull', user='puppet')


def install_puppet_module(module_name):
    sudo('puppet module install %s' % module_name)


def apply_puppet():
    sudo('/puppet/bin/apply.sh')


def add_roles(*roles):
    nodefile = "/puppet/hiera/nodespecific.yaml"

    contents = run('more %s' % nodefile).split('\n')
    new_contents = []
    existing_roles = []
    for line in contents:
        m = re.match('^roles: \[(.*)\]$', line)
        if m:
            existing_roles = [s.strip() for s in m.group(1).split(',')]
        else:
            new_contents.append(line.strip())

    roles = list(set(list(roles) + existing_roles))
    new_contents.append('roles: [%s]' % ', '.join(roles))
    new_contents = '\n'.join(new_contents)

    sudo('rm %s && touch %s' % (nodefile, nodefile))
    files.append(nodefile, new_contents, use_sudo=True)


def update_config():
    get_latest_config()
    relink_hiera()
    apply_puppet()


def is_puppetdb_ready():
    cmd = "wget --no-check-certificate --server-response https://%s 2>&1 | awk '/^  HTTP/{print $2}'" % env.puppetdb_url
    status = run(cmd)
    status = status.split('\n')[-1].strip()
    return status == '200'


def bootstrap(management=False, verbose=False):
    env.verbose = verbose == '1'
    management = management == '1'

    create_puppet_user()
    setup_keys()

    add_puppet_repo()
    update_puppet_version()
    install_modules()

    install_git()
    firstclone()

    set_facts()
    setup_hiera()
    if management:
        add_roles('management')

    include_apply_script()
    apply_puppet()

    # note: we do this twice the first time - the initial setup will also configure
    # puppetdb, and the second time will reconfigure using any information read from
    # puppetdb
    # note: this needs to wait for the puppetdb server to be actually responsive
    while not is_puppetdb_ready():
        time.sleep(1)
    apply_puppet()
