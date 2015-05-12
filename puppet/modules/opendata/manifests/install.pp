class opendata::install inherits opendata::params {

    include pythonsupport::standard
    include pythonsupport::psql

    class { '::ckan':
        site_url              => "http://${hostname}:${wsgi_port}",
        site_title            => 'Akvo Public Data',
        site_description      => 'A shared environment for managing Data.',
        site_intro            => 'Sharing data in an open format benefits the development sector and the general public at large. It encourages active use of valuable data, enables more connections and collaboration between practitioners and supports better decision-making by all.',
        site_about            => 'Currently there are over 600,000 data points in Akvo FLOW that are marked as public (i.e. they do not contain sensitive individual or household information) and this number is growing rapidly. To make such data easily accessible, searchable and downloadable we have set up this data portal to house such data.',
        # temporary disabled
        #site_logo            => "puppet:///modules/opendata/logo.png",
        plugins               => 'datastore stats text_preview recline_preview datapusher',
        app_instance_id       => hiera('ckan_app_instance_id'),
        beaker_secret         => hiera('ckan_beaker_secret'),
        is_ckan_from_repo     => 'false',
        ckan_package_url      => "http://packaging.ckan.org/python-ckan_${ckan_version}_amd64.deb",
        ckan_package_filename => "python-ckan_${ckan_version}_amd64.deb",
        setup_postgres_server => $setup_postgres,
        postgres_host         => hiera('external_ip'),
        storage_path          => $storage_path,
        backup_dir            => $backup_dir,
        datapusher_formats    => 'csv xls xlsx tsv application/csv application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        preview_loadable      => 'html htm rdf+xml owl+xml xml n3 n-triples turtle plain atom csv tsv rss txt json csv xls xlsx tsv application/csv application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        email_to              => 'opendata@akvo.org',
        err_email_from        => 'opendata@akvo.org',
        smtp_server           => 'mail.akvo.org'
    }

}
