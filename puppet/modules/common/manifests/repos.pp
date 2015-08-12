
class common::repos {

  # this is required to get other apt resources to function
  if !defined(Class['apt']) {
    class { 'apt': }

  }

  # add extra repos
  $repos = [
      'ppa:chris-lea/node.js',
      'ppa:nginx/stable',
      'ppa:gds/govuk'
  ]
  package { 'python-software-properties':
      ensure => 'latest'
  } ->
  apt::ppa { $repos: }

  # make sure the PPAs are added before any packages try to use them
  # except the ones depended on by Apt!
  Apt::Ppa<||> -> Package<| title != 'python-software-properties' |>

}
