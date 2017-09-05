class profile::php_composer {

    Exec {
      path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    }

    package { ['php-cli','php-xml','php-mbstring']:
      ensure  => installed,
    }

    exec {'install composer':
      cwd         => '/usr/local/bin',
      environment => 'HOME=/usr/local/bin',
      command     => 'curl -sS https://getcomposer.org/installer | /usr/bin/php && mv composer.phar /usr/local/bin/composer',
      creates     => '/usr/local/bin/composer',
      require     => Package['php-cli','php-xml'],
    }

}
