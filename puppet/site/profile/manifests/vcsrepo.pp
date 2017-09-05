class profile::vcsrepo (

  $repos = hiera_hash('vcsrepo::repos'),

  ){

  $defaults = {
    ensure => 'latest',
    provider => 'git',
    revision => 'master',
    depth => 1,
    require =>  Package['git','svn'],
  }
  create_resources('vcsrepo', $repos, $defaults)
}
