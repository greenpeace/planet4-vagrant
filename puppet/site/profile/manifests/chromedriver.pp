class profile::chromedriver (

  String $version = lookup(selenium::chromedriver_version),

  ){

    exec {'download chromedriver':
      command => "/bin/curl -sSo /tmp/chromedriver-${version}_linux64.zip https://chromedriver.storage.googleapis.com/${version}/chromedriver_linux64.zip",
      unless  => "/bin/test -f /usr/local/bin/chromedriver-${version}",
    }

    exec {'install chromedriver':
      command => "/bin/unzip /tmp/chromedriver-${version}_linux64.zip -d /tmp && /bin/mv -f /tmp/chromedriver /usr/local/bin/chromedriver-${version}",
      creates => "/usr/local/bin/chromedriver-${version}",
      require => [
          Exec['download chromedriver'],
          Package['unzip'],
        ],
    }

    file {'/usr/local/bin/chromedriver':
      ensure => 'link',
      target => "/usr/local/bin/chromedriver-${version}",
    }

    file {'/bin/chromedriver':
      ensure => 'link',
      target => "/usr/local/bin/chromedriver-${version}",
    }

}
