
class common::repos {

  # this is required to get other apt resources to function
  class { 'apt': }

  # add extra repos
  $repos = [
      'ppa:chris-lea/node.js',
      'ppa:nginx/stable'
  ]
  apt::ppa { $repos: }

  # make sure the PPAs are added before any packages try to use them
  # except the ones depended on by Apt!
  Apt::Ppa<||> -> Package<| title != 'python-software-properties' |>

}