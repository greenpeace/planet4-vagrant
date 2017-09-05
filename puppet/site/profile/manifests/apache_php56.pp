class profile::apache_php56 (

  $redis_master = lookup(php::redis_master),
  $redis_pass   = lookup(php::redis_pass),

  ){

  if $::osfamily == 'RedHat' or $::operatingsystem =~ /^[Aa]mazon$/ {

    class{ '::apache::mod::php':
      package_name => 'rh-php56-php',
      php_version  => '5.6',
      path         => 'modules/librh-php56-php5.so',
    }

    } else {
      fail("Class['profile::apache_php56']: Unsupported osfamily: ${::osfamily}")
  }

  file{ '/etc/opt/rh/rh-php56/php.d/50-redis.ini':
    ensure  => 'file',
    content => template('profile/php/redis.ini.erb'),
    require => Package['sclo-php56-php-pecl-redis'],
    notify  => Service['httpd24-httpd'],
  }

}
