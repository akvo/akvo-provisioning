import json
import os
import re
import sys
import tempfile
import time

import boto3

from fabric.api import cd, env, local, put, run, sudo
from fabric.contrib import files

from awsfabrictasks.ec2.tasks import *
from awsfabrictasks.regions import *
from awsfabrictasks.conf import *


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


def _get_key_file_path(keyname):
    return os.path.join(env.keys_dir, keyname)


def _get_config_file(filename):
    return os.path.join(env.config_dir, filename)


def _get_config_file_path(config_key, default_path=None):
    path = env.config.get(config_key)
    if path is None:
        if default_path is None:
            return None
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
        if default_path is None:
            return None
        return os.path.join(env.config_dir, default_path)


def _validate_config(config):
    pass


def _set_hosts():
    if len(env.hosts) > 0:
        # this was already set by the commandline
        # so just ignore our custom values
        return

    env.hosts = env.config['nodes'].keys()


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
        env.env_config_dir = os.path.join(env.config_dir, 'config')
        env.config_file = env_name_or_path
        print "Using configuration found at %s" % envfile
    else:
        # try to find it relative to the config root
        config_dir = os.environ.get('AKVO_CONFIG_DIR', None)
        if config_dir is None:
            sys.stderr.write("Cannot find config - the AKVO_CONFIG_DIR environment variable is not set.\n")
            sys.exit(1)

        env.env_config_dir = os.path.join(config_dir, 'config')
        env.config_dir = os.path.join(config_dir, env_name_or_path)
        env.keys_dir = os.path.join(config_dir, 'keys', env_name_or_path)

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
        env.keys_dir = '/puppet/checkout/config/keys/localdev/'

    if '-i' not in sys.argv:
        env.key_filename = env.config.get('puppet_private_key', _get_key_file_path('puppet'))

    _set_hosts()


# --------------------
# node configuration
# --------------------

def create_client_cert():
    """
    Generates a certificate and a private key to be used by the puppet client
    """
    # special case for vagrant and EC2 VMs: need to run as sudo
    if env.environment in ('localdev', 'ec2'):
        sudo('mkdir -p /var/lib/puppet/ssl/{private_keys,certs}')
        sudo('chown -R puppet.puppet /var/lib/puppet/ssl')
    else:
        run('mkdir -p /var/lib/puppet/ssl/{private_keys,certs}')
        run('chown -R puppet.puppet /var/lib/puppet/ssl')

    cacrt = _get_config_file_path('puppetdb_ca_cert') or _get_key_file_path('puppetdb-ca.crt')
    cakey = _get_config_file_path('puppetdb_ca_key') or _get_key_file_path('puppetdb-ca.key')

    # special case for vagrant and EC2 VMs: need to run as sudo
    if env.environment in ('localdev', 'ec2'):
        put(cacrt, '/var/lib/puppet/ssl/certs/ca.pem', use_sudo=True)
    else:
        put(cacrt, '/var/lib/puppet/ssl/certs/ca.pem')

    hostname = run('hostname -f').strip()

    with tempfile.NamedTemporaryFile() as keyfile:
        local('openssl genrsa -out %s 2048' % keyfile.name)
        with tempfile.NamedTemporaryFile() as csrfile:
            subj = '/CN=%s/O=akvo.org/C=NL' % hostname
            local('openssl req -new -key %s -out %s -subj "%s"' % (keyfile.name, csrfile.name, subj))
            with tempfile.NamedTemporaryFile() as crtfile:
                local('openssl x509 -req -days 3650 -in %s '
                      '-CA %s -CAkey %s -set_serial 01 -out %s' % (csrfile.name, cacrt, cakey, crtfile.name))

                # special case for vagrant and EC2 VMs: need to run as sudo
                if env.environment in ('localdev', 'ec2'):
                    put(keyfile.name, '/var/lib/puppet/ssl/private_keys/%s.pem' % hostname, use_sudo=True)
                    put(crtfile.name, '/var/lib/puppet/ssl/certs/%s.pem' % hostname, use_sudo=True)
                else:
                    put(keyfile.name, '/var/lib/puppet/ssl/private_keys/%s.pem' % hostname)
                    put(crtfile.name, '/var/lib/puppet/ssl/certs/%s.pem' % hostname)


def set_facts():
    """
    Sets default location for facter and adds the 'environment' fact
    """
    sudo('mkdir -p /etc/facter/facts.d')
    sudo('echo environment=%s >  /etc/facter/facts.d/akvo.txt' % env.environment)


def setup_hiera():
    """
    Sets default location and config file for hiera
    """
    sudo('mkdir -p /puppet/hiera/')
    sudo('chown -R puppet.puppet /puppet/hiera')
    put('files/hiera.yaml', '/etc/puppet/hiera.yaml', use_sudo=True)

    # relink_hiera(run_method=sudo)
    hiera_add_external_ip()


def create_hiera_facts(use_sudo=False):
    """
    Creates hiera facts based on server and environment JSON configuration files
    """
    run_method = sudo if use_sudo else run

    if env.environment == 'localdev':
        # if we are a vagrant VM, see if there are any host-specific files to copy in
        run_method('mkdir -p /puppet/hiera/envs/localdev/')
        put(os.path.join(env.config_dir, '*'), '/puppet/hiera/', use_sudo=use_sudo)
        hostname = run('hostname -f').strip()
        host_config = os.path.join(os.path.dirname(env.config_file), '%s.json' % hostname)
        if os.path.exists(host_config):
            put(host_config, '/puppet/hiera/envs/localdev/%s.json' % hostname, use_sudo=use_sudo)
    else:
        put(os.path.join(env.env_config_dir, '*'), '/puppet/hiera/', use_sudo=use_sudo)

    if use_sudo:
        sudo('chown -R puppet.puppet /puppet/hiera')


def hiera_add_external_ip():
    """
    Adds hiera facts for external and internal IP addresses
    """
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


def get_latest_config():
    """
    Pulls latest provisioning configuration (not applicable to vagrant boxes, i.e. 'localdev' environments)
    """
    if env.environment == 'localdev':
        print "Refusing to pull puppet, as this is a vagrant box and the checkout is linked to your host machine"
        return
    with cd('/puppet/checkout'):
        run('git pull')
        run('git submodule init')
        run('git submodule update --recursive')


def apply_puppet():
    """
    Executes `puppet apply` script as root user
    """
    run('sudo /puppet/bin/apply.sh')


def update_config():
    """
    Pulls latest provisioning configuration, creates hiera facts and applies puppet configuration
    """
    get_latest_config()
    create_hiera_facts()
    apply_puppet()


# --------------------
# bootstrapping specific
# --------------------

def set_hostname():
    """
    Sets hostname everywhere
    """
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
    # fix permissions
    sudo('chown -R puppet.puppet /puppet')


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
    """
    Installs 'git' package
    """
    flags = '-q' if env.verbose else '-qq'
    sudo('apt-get install -y %s git' % flags)


def install_puppet_module(module_name):
    """
    Installs a given puppet module
    """
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
            sudo('git clone https://github.com/akvo/akvo-provisioning.git checkout', user='puppet')
            sudo('chown -R puppet.puppet /puppet/checkout')
            with cd('/puppet/checkout'):
                puppet_branch = env.config.get('puppet_branch', 'master')
                sudo('git checkout %s' % puppet_branch, user='puppet')
                sudo('git submodule init')
                sudo('git submodule update --recursive')


def reset_checkout(branch_name=None):
    """
    Resets puppet checkout to the HEAD of a given git branch
    """
    run('rm -rvf /puppet/checkout /puppet/checkout.old')
    run('git clone https://github.com/akvo/akvo-provisioning.git /puppet/checkout')
    with cd('/puppet/checkout'):
        puppet_branch = branch_name or env.config.get('puppet_branch', 'master')
        run('git checkout %s' % puppet_branch)
        run('git submodule init')
        run('git submodule update --recursive')


def include_apply_script():
    """
    Adds `puppet apply` bash script for provisioning
    """
    sudo('mkdir -p /puppet/bin/')
    put('files/apply.sh', '/puppet/bin/apply.sh', use_sudo=True)
    sudo('chown -R puppet.puppet /puppet/bin/')
    sudo('chmod 700 /puppet/bin/apply.sh')


def use_bootstrap_credentials():
    """
    Sets bootstrap credentials to environment configuration
    """
    env.user = env.config.get('bootstrap_username', 'root')
    env.password = env.config.get('bootstrap_password')
    env.key_filename = env.config.get('bootstrap_key_filename')


def is_puppetdb_ready():
    """
    Check if puppetdb service is ready
    """
    hostname = run('hostname -f').strip()
    key = "--private-key=/var/lib/puppet/ssl/private_keys/%s.pem" % hostname
    cert = "--certificate=/var/lib/puppet/ssl/certs/%s.pem" % hostname

    puppetdb_server = env.config.get('puppetdb', 'puppetdb')
    if env.environment == 'localdev':
        cmd = str("wget --no-check-certificate %s %s "
                  "--server-response https://%s:8443 2>&1 | "
                  "awk '/^  HTTP/{print $2}'") % (key, cert, puppetdb_server)
    else:
        cmd = str("wget --no-check-certificate %s %s "
                  "--server-response https://%s 2>&1 | "
                  "awk '/^  HTTP/{print $2}'") % (key, cert, puppetdb_server)

    status = sudo(cmd)
    status = status.split('\n')[-1].strip()
    return status == '200'


def bootstrap(verbose=False):
    """
    Performs all tasks needed to bootstrap the environment.
    It includes basic steps to setup the server by means of puppet configuration
    """
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
# management
# --------------------

def upgrade_packages(y=None):
    """
    Upgrades a given package
    """
    # not sure why, but using fabric's sudo method
    # will not work here with the sudoers.d config which
    # allows puppet to run apt-get...
    y = '-y' if y is not None else ''
    run('sudo apt-get update')
    run('sudo apt-get upgrade %s' % y)


def upgrade_packages_dist():
    """
    Performs a distribution upgrade
    """
    upgrade_packages()
    run('sudo apt-get dist-upgrade')


def reboot():
    """
    Reboots the host
    """
    run('hostname -f')
    run('sudo reboot')


# --------------------
# shortcuts
# --------------------

def admin():
    """
    Sets the 'admin' environment up
    """
    on_environment('admin')


def test():
    """
    Sets the 'test' environment up
    """
    on_environment('test')


def opstest():
    """
    Sets the 'opstest' environment up
    """
    on_environment('opstest')


def uat():
    """
    Sets the 'uat' environment up
    """
    on_environment('uat')


def live():
    """
    Sets the 'live' environment up
    """
    on_environment('live')


def support():
    """
    Sets the 'support' environment up
    """
    on_environment('support')


def up():
    """
    Sets the 'up' environment up
    """
    update_config()


# ---------------------------
# Akvo AWS EC2 tasks
# ---------------------------

@task
def ec2_create_volume(size, availability_zone="eu-west-1c" volume_type="gp2"):
    """
    Creates an encrypted EBS volume of the given size and volume type
    """
    local("""aws ec2 create-volume --encrypted --output json --size %d \
             --availability-zone %s --volume-type %s""" % (size, availability_zone, volume_type))


@task
def ec2_attach_volume(volume_id, instance_id, device="/dev/sdf"):
    """
    Attaches the given EBS volume to the given EC2 instance
    """
    ec2 = boto3.resource("ec2")
    volume = ec2.Volume(volume_id)
    volume.attach_to_instance(dict(InstanceId=instance_id, Device=device))
