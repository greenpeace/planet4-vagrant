class profile::chrome {

  if $::osfamily == 'RedHat' or $::operatingsystem =~ /^[Aa]mazon$/ {

    file {'install Chrome repo':
      ensure => 'present',
      path   => '/etc/yum.repos.d/google-chrome.repo',
      source => 'puppet:///modules/profile/chrome/google-chrome.repo',
      before => Package['google-chrome-stable'],
    }

    package {'google-chrome-stable':
    ensure => present,
    }

  } else {
    fail("Class['profile::chrome']: Unsupported osfamily: ${::osfamily}")
  }
}
