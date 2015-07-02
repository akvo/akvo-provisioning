
class keycloak inherits keycloak::params {

    class { 'keycloak::install': } ->
    class { 'keycloak::config': } ~>
    class { 'keycloak::service': } ->
    Class['keycloak']

}