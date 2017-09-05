class profile::selenium_node (

  $selenium_hub = lookup(selenium::selenium_hub),
  $node_options = lookup(selenium::node_options),

){
  if $::osfamily == 'RedHat' or $::operatingsystem =~ /^[Aa]mazon$/ {
    exec {'install EPEL repo':
      command => '/bin/yum -d 0 -e 0 -y install epel-release',
      creates => '/etc/yum.repos.d/epel.repo',
      before  => Class['display'],
    }
  }


  include java

  class { 'display':
    width  => 1680,
    height => 1050,
    }
  class { 'selenium::node':
    display => ':0',
    options => $node_options,
    hub     => "http://${selenium_hub}:4444/grid/register",
  }

  Class['java'] -> Class['display'] -> Class['selenium::node']
}
