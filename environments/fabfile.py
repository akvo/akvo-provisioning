from fabric.api import local, run, env, cd, prefix, sudo, settings, put
from fabric.contrib import files
import re
import time
import json
import os
import sys


# note: 'roles' is used to map a hostname onto the list of roles that it will aquire
# and perform. This is not the same as the fabric concept of "roles".

env.user = 'puppet'

def _set_hosts():
    if len(env.hosts) > 0:
        # this was already set by the commandline
        # so just ignore our custom values
        return

    hosts = []
    for host, config in env.config['nodes'].iteritems():
        hosts.append( (host, config.get('order', 0), 'management' in config['roles']) )
    def sort_nodes(node1, node2):
        if node1[2]:
            return -1
        if node2[2]:
            return 1
        return node2[1] - node1[1]

    hosts = sorted(hosts, cmp=sort_nodes)
    env.hosts = [x[0] for x in hosts]

    print "Host order:\n%s" % '\n'.join(env.hosts)

def _get_relative_file(*path_parts):
    parts = (os.path.dirname('__file__'),) + (path_parts)
    return os.path.join( *parts )


def on_environment(env_name_or_path):
    """
    Sets the environment up using the given name or file

    :param env_name_or_path: Either the name of an environment, or a path
        to an environment definition file
    """
    envfile = _get_relative_file('config', '%s.json' % env_name_or_path)
    if not os.path.exists(envfile):
        if not os.path.exists(env_name_or_path):
            print "Could not find environment: %s" % env_name_or_path
            sys.exit(1)
        envfile = env_name_or_path

    with open(envfile) as f:
        env_config = json.load(f)

    env.config = env_config
    env.environment = env.config['name']
    env.key_filename = env.config.get('puppet_public_key', _get_relative_file('keys', '%s_puppet' % env.environment))

    _set_hosts()




# helpers
def _get_node_config(setting_name, default=KeyError):
    conf = env.config['nodes'][env.host_string]
    if default == KeyError:
        return conf['setting_name']
    return conf.get(setting_name, default)

def _get_current_roles():
    return _get_node_config('roles', [])


# commands
def echo_test():
    sudo('echo test')


def set_hostname():
    nodename = _get_node_config('nodename', None)
    if nodename is None:
        print "Not setting hostname as no nodename was set"
        return

    hostname = '%s.%s' % (nodename, env.config['base_domain'])
    print "Setting hostname to %s" % hostname

    # remove the current hostname from /etc/hosts
    current_hostname = run('hostname -f').strip()
    sudo('sed "/%s/d" -i /etc/hosts' % current_hostname)

    # set the hostname everywhere
    sudo('echo "127.0.0.1 %s %s" >> /etc/hosts' % (hostname, nodename))
    sudo('hostname %s' % hostname)
    sudo('echo %s > /etc/hostname' % hostname)


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
    put('files/github_deploy_key', '/puppet/.ssh/id_rsa', use_sudo=True)
    # fix permissions
    sudo('chown -R puppet.puppet /puppet')
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


def install_puppet_module(module_name):
    sudo('puppet module install %s' % module_name)


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
            with cd('/puppet/checkout'):
                puppet_branch = env.config.get('puppet_branch', 'master')
                sudo('git checkout %s' % puppet_branch, user='puppet')


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
    relink_hiera(run_method=sudo)
    hiera_add_external_ip()
    sudo('echo "base_domain: %s" >> /puppet/hiera/nodespecific.yaml' % env.config['base_domain'])

    keyfile = env.config.get('puppet_public_key', _get_relative_file('keys', '%s_puppet.pub' % env.environment))
    with open(keyfile) as f:
        puppet_public_key = f.read().replace('\n','')
    keyval = "'%s'" % puppet_public_key.replace('ssh-rsa ','')
    sudo('echo "puppet_public_key: %s" >> /puppet/hiera/nodespecific.yaml' % keyval)


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
            if env.config['machine_type'] == 'vagrant':
                external_ip_addr = ip_addr
        else:
            external_ip_addr = ip_addr

    if external_ip_addr is None:
        # if we can't find one on our own interfaces, try an external tool
        external_ip_addr = sudo('wget http://ipecho.net/plain -O - -q').strip()

    if internal_ip_addr is None:
        # if we only have an external IP, we'll have to use that for everything
        internal_ip_addr = external_ip_addr

    sudo("sed -i '/external_ip/d' /puppet/hiera/nodespecific.yaml")
    sudo("sed -i '/internal_ip/d' /puppet/hiera/nodespecific.yaml")
    sudo("sed -i '/machine_type/d' /puppet/hiera/nodespecific.yaml")

    sudo('echo "external_ip : %s" >> /puppet/hiera/nodespecific.yaml' % external_ip_addr)
    sudo('echo "internal_ip : %s" >> /puppet/hiera/nodespecific.yaml' % internal_ip_addr)
    sudo('echo "machine_type : %s" >> /puppet/hiera/nodespecific.yaml' % env.config['machine_type'])


def relink_hiera(run_method=run):
    run_method('find /puppet/hiera/ -type l -delete')
    run_method('ln -s /puppet/checkout/hiera/* /puppet/hiera/')


def get_latest_config():
    if env.environment == 'localdev':
        print "Refusing to pull puppet, as this is a vagrant box and the checkout is linked to your host machine"
        return
    with cd('/puppet/checkout'):
        run('git pull')


def apply_puppet():
    run('sudo /puppet/bin/apply.sh')


def add_roles(*roles):
    nodefile = "/puppet/hiera/nodespecific.yaml"

    contents = run('more %s' % nodefile).split('\n')
    existing_roles = []
    for line in contents:
        m = re.match('^roles: \[(.*)\]$', line)
        if m:
            existing_roles = [s.strip() for s in m.group(1).split(',')]

    roles = list(set(list(roles) + existing_roles))

    sudo("sed -i '/roles:/d' %s" % nodefile)
    files.append(nodefile, 'roles: [%s]' % ', '.join(roles), use_sudo=True)


def update_config():
    get_latest_config()
    relink_hiera()
    apply_puppet()


def is_puppetdb_ready():
    cmd = "wget --no-check-certificate --server-response https://puppetdb.%s 2>&1 | awk '/^  HTTP/{print $2}'" % env.config['base_domain']
    status = run(cmd)
    status = status.split('\n')[-1].strip()
    return status == '200'


def use_bootstrap_credentials():
    env.user = env.config.get('bootstrap_username', 'root')
    env.password = env.config.get('bootstrap_password')
    env.key_filename = env.config.get('bootstrap_key_filename')


def bootstrap(verbose=False):
    use_bootstrap_credentials()

    env.verbose = verbose == '1'
    management = 'management' in _get_current_roles()
    if management:
        print "This is a management node"

    set_hostname()

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
    # run the first time just setting up the basic information
    sudo('/puppet/bin/apply.sh')

    # now add the rest of the roles which are now configurable
    add_roles(*_get_current_roles())

    # note: we do this twice the first time - the initial setup will also configure
    # puppetdb, and the second time will reconfigure using any information read from
    # puppetdb, and will install anything from the additional roles
    # note: this needs to wait for the puppetdb server to be actually responsive
    while not is_puppetdb_ready():
        time.sleep(1)
    sudo('/puppet/bin/apply.sh')
