class profile::wordpress (
  $wp_cli      = lookup(wordpress::wp_cli),
  $site_url    = lookup(wordpress::site_url),
  $site_title  = lookup(wordpress::site_title),
  $site_user   = lookup(wordpress::site_user),
  $site_email  = lookup(wordpress::site_email),
  $db_name     = lookup(wordpress::db_name),
  $db_user     = lookup(wordpress::db_user),
  $db_password = lookup(wordpress::db_password),
  $db_host     = lookup(wordpress::db_host),
){

  exec {'install composer':
    cwd         => '/usr/local/bin',
    environment => 'HOME=/usr/local/bin',
    path        => '/sbin:/bin:/usr/sbin:/usr/bin:',
    command     => 'curl -sS https://getcomposer.org/installer | /bin/php && mv composer.phar /usr/local/bin/composer',
    creates     => '/usr/local/bin/composer',
    require     => Package['php'],
  }

  file { '/var/www/html':
    ensure  => 'directory',
    owner   => 'planet4',
    group   => 'planet4',
    recurse => true,
    require => Vcsrepo['/var/www/html'],
  }

  file { $wp_cli:
    ensure  => 'file',
    owner   => 'planet4',
    group   => 'planet4',
    content => template('profile/wordpress/wp-cli.erb'),
    require => File['/var/www/html'],
  }

  exec {'composer install':
    cwd         => '/var/www/html',
    environment => 'HOME=/home/planet4',
    command     => '/bin/sudo -u planet4 -- /usr/local/bin/composer install',
    creates     => '/var/www/html/vendor',
    require     => [ Exec['install composer'] , File['/var/www/html'] ],
  }

  exec {'composer site-install':
    cwd         => '/var/www/html',
    environment => 'HOME=/home/planet4',
    command     => '/bin/sudo -u planet4 -- /usr/local/bin/composer run-script site-install | /bin/tee /root/site-install.log',
    creates     => '/var/www/html/public/wp-config.php',
    require     => [ Exec['composer install'] , File[$wp_cli] ],
    notify      => Exec['selinux httpd allow db connect','display wp-admin password'],
  }

  exec { 'display wp-admin password':
    command     => '/bin/grep password /root/site-install.log',
    onlyif      => ['/bin/test -e /root/site-install.log','/bin/grep password /root/site-install.log'],
    refreshonly => true,
    logoutput   => true,
  }

  exec { 'selinux httpd allow db connect':
    command     => '/sbin/setsebool -P httpd_can_network_connect_db 1',
    refreshonly => true,
  }

}
