class profile::apache24 (

  $default_vhost = false,
  $docroot       = '/var/www/html',
  $vhosts        = hiera_hash('apache::vhosts'),

  ){

  if $::osfamily == 'RedHat' or $::operatingsystem =~ /^[Aa]mazon$/ {

    file {'/etc/httpd/':
      ensure => 'link',
      target => '/opt/rh/httpd24/root/etc/httpd/',
    }

    exec {'install SCL repo':
      command => '/bin/yum -d 0 -e 0 -y install centos-release-scl',
      creates => '/etc/yum.repos.d/CentOS-SCLo-scl.repo',
    }

    class{ '::apache':
      default_vhost => $default_vhost,
      docroot       => $docroot,
      require       => Exec['install SCL repo'],
    }

    create_resources('apache::vhost', $vhosts)

  } else {
    fail("Class['profile::apache24']: Unsupported osfamily: ${::osfamily}")
  }
}
