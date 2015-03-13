
class role::dataserver {

    notice('Including role: data server')

    include pythonsupport::standard
    include pythonsupport::psql

    class { '::ckan':
       site_url              => '',
       site_title            => 'Akvo Public Data',
       site_description      => 'A shared environment for managing Data.',
       site_intro            => 'A CKAN test installation',
       site_about            => 'Data server.',
       plugins               => 'datastore stats text_preview recline_preview',
       app_instance_id       => hiera('ckan_app_instance_id'),
       beaker_secret         => hiera('ckan_beaker_secret'),
       is_ckan_from_repo     => 'false',
       ckan_package_url      => 'http://packaging.ckan.org/python-ckan_2.3_amd64.deb',
       ckan_package_filename => 'python-ckan_2.3_amd64.deb',
       setup_postgres_server => false,
       postgres_host         => hiera('external_ip'),
       storage_path          => '/var/lib/ckan',
       backup_dir            => '/backups/data/psql/daily'
    }

    firewall { '200 allow httpd access':
        port   => [80, 443],
        proto  => tcp,
        action => accept,
    }

    # we want the 'backup' user to be able to execute 'ckan' in order to perform backups
    sudo::allow_command { "dataserver-backup-ckan":
        user    => 'backup',
        command => '/usr/bin/ckan'
    }

}
