class profile::selenium_hub {
  include java

  class { 'selenium::hub': }

  Class['java'] -> Class['selenium::hub']
}
