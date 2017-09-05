class profile::php_composer70 {

  if $::osfamily == 'RedHat' or $::operatingsystem =~ /^[Aa]mazon$/ {

    Exec {
      path => '/opt/rh/rh-php70/root/usr/bin:/opt/rh/rh-php70/root/usr/sbin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    }

    exec {'install SCL repo':
      command => '/bin/yum -d 0 -e 0 -y install centos-release-scl',
      creates => '/etc/yum.repos.d/CentOS-SCLo-scl.repo',
    }

    package { ['rh-php70-php-cli','rh-php70-php-xml','rh-php70-php-mbstring']:
      ensure  => installed,
      require => Exec['install SCL repo'],
    }

    exec {'install composer70':
      cwd         => '/usr/local/bin',
      environment => 'HOME=/usr/local/bin',
      command     => 'curl -sS https://getcomposer.org/installer | /opt/rh/rh-php70/root/usr/bin/php && mv composer.phar /usr/local/bin/composer70',
      creates     => '/usr/local/bin/composer70',
      require     => Package['rh-php70-php-cli','rh-php70-php-xml'],
    }

  } else {
    fail("Class['profile::php_composer70']: Unsupported osfamily: ${::osfamily}")
  }

}
