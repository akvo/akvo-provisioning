from fabric.api import local, run, env, cd, prefix, sudo, settings, put
from fabric.contrib import files
import time
import os
import tempfile
import sys
import re
import json


# --------------------
# defaults
# --------------------
if '--user' not in sys.argv:
    env.user = 'puppet'


# --------------------
# helper functions
# --------------------

def _get_node_config(setting_name, default=KeyError):
    conf = env.config['nodes'][env.host_string]
    if default == KeyError:
        return conf['setting_name']
    return conf.get(setting_name, default)


def _get_config_file(filename):
    return os.path.join(env.config_dir, filename)


def _get_config_file_path(config_key, default_path):
    path = env.config.get(config_key)
    if path is None:
        # not specified, so fall back on the default path, which might be relative to the config dir
        return os.path.join(env.config_dir, default_path)

    if path.startswith('config://'):
        # this sort-of scheme indicates that we want to use another (predefined) environment's config
        base_dir = os.environ.get('AKVO_CONFIG_DIR', None)
        # we expect 'config://<envname>/<relative_path>'
        match = re.match(r'^config://(\w+)/(.*)$', path)
        if match is None:
            sys.stderr("Could not parse config location: %s" % path)
            sys.exit(1)
        env_name = match.group(1)
        relpath = match.group(2)
        return os.path.join(base_dir, env_name, relpath)
    else:
        # we will assume that the path is absolute, or relative to our config dir
        return os.path.join(env.config_dir, default_path)


def _validate_config(config):
    pass


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


# --------------------
# environment configuration setup
# --------------------

def on_environment(env_name_or_path):
    """
    Sets the environment up using the given name or file

    :param env_name_or_path: Either the name of an environment, or a path
        to an environment definition file
    """
    envfile = os.path.abspath(os.path.expanduser(env_name_or_path))
    if os.path.exists(envfile):
        env.config_dir = os.path.dirname(envfile)
        env.config_file = env_name_or_path
        print "Using configuration found at %s" % envfile
    else:
        # try to find it relative to the config root
        config_dir = os.environ.get('AKVO_CONFIG_DIR', None)
        if config_dir is None:
            sys.stderr.write("Cannot find config - the AKVO_CONFIG_DIR environment variable is not set.\n")
            sys.exit(1)

        env.config_dir = os.path.join(config_dir, env_name_or_path)

        envfile = _get_config_file('config.json')
        if not os.path.exists(envfile):
            sys.stderr.write("No such config file: %s" % envfile)
            sys.exit(1)

    with open(envfile) as f:
        env_config = json.load(f)

    _validate_config(env_config)

    env.config = env_config
    env.environment = env.config['name']

    if env.environment == 'localdev':
        # special case for vagrant VMs: rather than using configuration next to the vagrant
        # environment definition ('localdev_puppet.json' for example), we'll use the defaults
        # in the provisioning repository, which is available at '/puppet/checkout' on vagrant
        # VMs (hopefully...)
        print "This is a Vagrant VM, so using puppet checkout dir for config"
        env.config_dir = '/puppet/checkout/config/'

    if '-i' not in sys.argv:
        env.key_filename = _get_config_file_path('puppet_private_key', 'keys/%s/puppet' % env.environment)

    _set_hosts()


# --------------------
# node configuration
# --------------------

def create_client_cert():
    sudo('mkdir -p /var/lib/puppet/ssl/{private_keys,certs}')
    sudo('chown -R puppet.puppet /var/lib/puppet/ssl')

    cacrt = _get_config_file_path('puppetdb_ca_cert', 'keys/%s/puppetdb-ca.crt' % env.environment)
    cakey = _get_config_file_path('puppetdb_ca_key', 'keys/%s/puppetdb-ca.key' % env.environment)
    put(cacrt, '/var/lib/puppet/ssl/certs/ca.pem', use_sudo=True)
    hostname = run('hostname -f').strip()

    with tempfile.NamedTemporaryFile() as keyfile:
        local('openssl genrsa -out %s 2048' % keyfile.name)
        with tempfile.NamedTemporaryFile() as csrfile:
            subj = '/CN=%s/O=akvo.org/C=NL' % hostname
            local('openssl req -new -key %s -out %s -subj "%s"' % (keyfile.name, csrfile.name, subj))
            with tempfile.NamedTemporaryFile() as crtfile:
                local('openssl x509 -req -days 3650 -in %s '
                      '-CA %s -CAkey %s -set_serial 01 -out %s' % (csrfile.name, cacrt, cakey, crtfile.name))

                put(keyfile.name, '/var/lib/puppet/ssl/private_keys/%s.pem' % hostname, use_sudo=True)
                put(crtfile.name, '/var/lib/puppet/ssl/certs/%s.pem' % hostname, use_sudo=True)


def set_facts():
    sudo('mkdir -p /etc/facter/facts.d')
    sudo('echo environment=%s >  /etc/facter/facts.d/akvo.txt' % env.environment)


def setup_hiera():
    sudo('mkdir -p /puppet/hiera/')
    sudo('chown -R puppet.puppet /puppet/hiera')
    put('files/hiera.yaml', '/etc/puppet/hiera.yaml', use_sudo=True)

    # relink_hiera(run_method=sudo)
    hiera_add_external_ip()


def create_hiera_facts(use_sudo=False):
    put(os.path.join(env.config_dir, '*'), '/puppet/hiera/', use_sudo=use_sudo)

    run_method = sudo if use_sudo else run
    if env.environment == 'localdev':
        # if we are a vagrant VM, see if there are any host-specific files to copy in
        run_method('mkdir -p /puppet/hiera/envs/localdev/')
        hostname = run('hostname -f').strip()
        host_config = os.path.join(os.path.dirname(env.config_file), '%s.json' % hostname)
        if os.path.exists(host_config):
            put(host_config, '/puppet/hiera/envs/localdev/%s.json' % hostname, use_sudo=use_sudo)

    if use_sudo:
        sudo('chown -R puppet.puppet /puppet/hiera')


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

    facts = {
        'internal_ip': internal_ip_addr,
        'external_ip': external_ip_addr
    }
    facts = json.dumps(facts, indent=2)

    with tempfile.NamedTemporaryFile() as facts_json:
        facts_json.write(facts)
        facts_json.flush()
        put(facts_json.name, '/puppet/hiera/nodefacts.json', use_sudo=True)
    sudo('chown puppet.puppet /puppet/hiera/nodefacts.json')


# --------------------
# bootstrapping specific
# --------------------

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
    repository on GitHub
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
                sudo('git submodule init')
                sudo('git submodule update --recursive')


def include_apply_script():
    sudo('mkdir -p /puppet/bin/')
    put('files/apply.sh', '/puppet/bin/apply.sh', use_sudo=True)
    sudo('chown -R puppet.puppet /puppet/bin/')
    sudo('chmod 700 /puppet/bin/apply.sh')


def use_bootstrap_credentials():
    env.user = env.config.get('bootstrap_username', 'root')
    env.password = env.config.get('bootstrap_password')
    env.key_filename = env.config.get('bootstrap_key_filename')


def is_puppetdb_ready():
    hostname = run('hostname -f').strip()
    key = "--private-key=/var/lib/puppet/ssl/private_keys/%s.pem" % hostname
    cert = "--certificate=/var/lib/puppet/ssl/certs/%s.pem" % hostname

    puppetdb_server = env.config.get('puppetdb', 'puppetdb')
    cmd = "wget --no-check-certificate %s %s --server-response https://%s 2>&1 | awk '/^  HTTP/{print $2}'" % (key, cert, puppetdb_server)
    status = sudo(cmd)
    status = status.split('\n')[-1].strip()
    return status == '200'


def bootstrap(verbose=False):
    use_bootstrap_credentials()

    env.verbose = verbose == '1'

    set_hostname()

    create_puppet_user()
    setup_keys()

    add_puppet_repo()
    update_puppet_version()
    install_modules()
    create_client_cert()

    install_git()
    firstclone()

    set_facts()
    setup_hiera()
    create_hiera_facts(use_sudo=True)

    include_apply_script()
    sudo('/puppet/bin/apply.sh')

    # note: we do this twice the first time - the initial setup will also configure
    # puppetdb, and the second time will reconfigure using any information read from
    # puppetdb, and will install anything from the additional roles
    # note: this needs to wait for the puppetdb server to be actually responsive
    while not is_puppetdb_ready():
        time.sleep(1)
    sudo('/puppet/bin/apply.sh')


# --------------------
# shortcuts
# --------------------

def admin():
    on_environment('admin')


def test():
    on_environment('test')


def opstest():
    on_environment('opstest')


def uat():
    on_environment('uat')


def live():
    on_environment('live')


def up():
    update_config()