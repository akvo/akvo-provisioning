class opendata::install {

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
        ckan_package_url      => "http://packaging.ckan.org/python-ckan_${opendata::params::ckan_version}_amd64.deb",
        ckan_package_filename => "python-ckan_${opendata::params::ckan_version}_amd64.deb",
        setup_postgres_server => $opendata::params::setup_postgres,
        postgres_host         => hiera('external_ip'),
        storage_path          => $opendata::params::storage_path,
        backup_dir            => $opendata::params::backup_dir
    }

}
