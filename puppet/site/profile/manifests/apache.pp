class profile::apache (

  $default_vhost = false,
  $docroot       = '/var/www/html',
  $vhosts        = hiera_hash('apache::vhosts'),

  ){

  class{ '::apache':
  default_vhost => $default_vhost,
  docroot       => $docroot,
  }

  create_resources('apache::vhost', $vhosts)

}
