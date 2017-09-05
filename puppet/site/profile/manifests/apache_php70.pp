class profile::apache_php70 (

  $redis_master = lookup(php::redis_master),
  $redis_pass   = lookup(php::redis_pass),

  ){

  if $::osfamily == 'RedHat' or $::operatingsystem =~ /^[Aa]mazon$/ {

    class{ '::apache::mod::php':
      package_name => 'rh-php70-php',
      php_version  => '7.0',
      path         => 'modules/librh-php70-php7.so',
    }

    } else {
      fail("Class['profile::apache_php70']: Unsupported osfamily: ${::osfamily}")
  }

  file{ '/etc/opt/rh/rh-php70/php.d/50-redis.ini':
    ensure  => 'file',
    content => template('profile/php/redis.ini.erb'),
    require => Package['sclo-php70-php-pecl-redis'],
    notify  => Service['httpd24-httpd'],
  }

}
