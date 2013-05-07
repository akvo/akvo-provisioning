from fabric.api import local, run, env, cd, prefix, sudo, settings, put

env.user = 'root'




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
    run('id -u puppet 2>&1 >/dev/null || adduser puppet --home=/puppet/')


def setup_keys():
    """
    Copies the puppet key for the puppet user, which grants access to the puppet
    repository on GitHub as well as allows login from the management machines to
    execute puppet updates
    """
    run('mkdir -p /puppet/.ssh')
    run('chown -R puppet.puppet /puppet')

    put('puppet.id_rsa.pub', '/puppet/.ssh/id_rsa.pub')
    run('chown 644 /puppet/.ssh/id_rsa.pub')

    put('puppet.id_rsa', '/puppet/.ssh/id_rsa')
    run('chown 600 /puppet/.ssh/id_rsa')



def add_puppet_repo():
    """
    Adds the puppet apt repository. The version of puppet in the default Ubuntu 12.04 repositories
    is puppet 2.7.x, but we want to use puppet 3+
    """
    env.key_filename = ['~/.ssh/servers']
    run('echo -e "deb http://apt.puppetlabs.com/ precise main\ndeb-src http://apt.puppetlabs.com/ precise main" >> /etc/apt/sources.list')
    run('apt-key adv --keyserver keyserver.ubuntu.com --recv 4BD6EC30')
    run('apt-get update')
    run('apt-get install puppet mercurial')


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
    env.user = 'puppet'
    with cd('/puppet'):
        run('git clone ssh://git@bitbucket.org/carlio/akvo-puppet/')


def apt_update():
    sudo('apt-get update')


def bootstrap():
    create_puppet_user()
    setup_keys()
    add_puppet_repo()
    install_modules()
    firstclone()


def update():
    with cd('/puppet/puppet'):
        run('hg pull -u')
        
def apply():
    sudo('puppet apply --modulepath=/etc/puppet/modules:/usr/share/puppet/modules:/puppet/puppet/modules -v /puppet/puppet/manifests/site.pp')
