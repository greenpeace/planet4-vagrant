class profile::geckodriver (

  $geckodriver_version = lookup(selenium::geckodriver_version),

){

    Exec {
      path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin',
    }

    file {'geckodriver directory':
      ensure => 'directory',
      path   => "/opt/geckodriver-v${geckodriver_version}",
    }

    exec {'download geckodriver':
      cwd     => "/opt/geckodriver-v${geckodriver_version}",
      command => "/bin/curl -L -O https://github.com/mozilla/geckodriver/releases/download/v${geckodriver_version}/geckodriver-v${geckodriver_version}-linux64.tar.gz",
      creates => "/opt/geckodriver-v${geckodriver_version}/geckodriver-v${geckodriver_version}-linux64.tar.gz",
      require => File['geckodriver directory'],
    }

    exec {'extract geckodriver':
      cwd     => "/opt/geckodriver-v${geckodriver_version}",
      command => "/bin/tar -zxf geckodriver-v${geckodriver_version}-linux64.tar.gz",
      creates => "/opt/geckodriver-v${geckodriver_version}/geckodriver",
      require => Exec['download geckodriver'],
    }

    file {'geckodriver binary':
      ensure  => 'present',
      path    => "/opt/geckodriver-v${geckodriver_version}/geckodriver",
      mode    => '0755',
      require => Exec['extract geckodriver'],
    }

    file {'/usr/bin/geckodriver':
      ensure  => 'link',
      target  => "/opt/geckodriver-v${geckodriver_version}/geckodriver",
      require => File['geckodriver binary'],
    }

}
