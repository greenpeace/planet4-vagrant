class profile::apache_php54 (

  $redis_master = lookup(php::redis_master),
  $redis_pass   = lookup(php::redis_pass),

  ){

  class{ '::apache::php':}

  file{ '/etc/php.d/redis.ini':
    ensure  => 'file',
    content => template('profile/php/redis.ini.erb'),
    require => Package['php-pecl-redis'],
    notify  => Service['httpd'],
  }

}
