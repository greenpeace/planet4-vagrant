class profile::base (

  $motd_ascii                      = generate('/bin/sh', '-c', "/usr/bin/figlet -c -w 80 ${::hostname}"),
  $motd_timestamp                  = generate('/bin/sh', '-c', '/bin/date -d now +%F'),
  $packages                        = hiera_hash('base::packages'),
  $users                           = hiera_hash('accounts::users'),
  $permit_root_login               = lookup(ssh::permit_root_login),
  $sshd_password_authentication    = lookup(ssh::sshd_password_authentication),
  $sshd_config_challenge_resp_auth = 'no',
  $firewall_rules                  = hiera_hash('base::firewall'),
  $selinux_mode                    = lookup('selinux::selinux_mode'),

){
  # Manage NTP
  include ntp

  # Manage Time Zone
  include timezone

  # Manage Base Packages
  create_resources('package', $packages)

  # Manage User Accounts
  create_resources('accounts::user', $users)

  # Manage Message Of The Day file
  class{ '::motd':
    template => 'profile/motd/motd.erb',
  }

  # Manage SSH
  class{ '::ssh':
    permit_root_login               => $permit_root_login,
    sshd_password_authentication    => $sshd_password_authentication,
    sshd_config_challenge_resp_auth => $sshd_config_challenge_resp_auth,
    sshd_config_banner              => '/etc/pre-login.message',
    sshd_banner_content             => "
       For site security purposes, and to ensure that this
       service remains available to all users, all network
       traffic is monitored in order to identify unauthorized
       attempts to upload or change information, or otherwise
       cause damage or conduct criminal activity. To protect
       the system from unauthorized use and to ensure that the
       system is functioning properly, individuals using this
       computer system are subject to having all of their
       activities monitored and recorded by system personnel.
       Anyone using this system expressly consents to such
       monitoring and is advised that if such monitoring reveals
       evidence of possible abuse or criminal activity, system
       personnel may provide the results of such monitoring to
       appropriate officials. Unauthorized attempts to upload
       or change information on this service are strictly
       prohibited and may be punishable under applicable
                     federal law.\n"
  }

  # Manage iptables
  resources { 'firewall':
    purge => false,
  }

  resources { 'firewallchain':
    purge => false,
  }

  contain '::profile::firewall_pre'
  contain '::profile::firewall_post'

  Firewall {
    before  => Class['::profile::firewall_post'],
    require => Class['::profile::firewall_pre'],
  }

  class { '::firewall': }

  create_resources('firewall', $firewall_rules)

  # Manage SELinux
  if $::osfamily == 'RedHat' or $::operatingsystem =~ /^[Aa]mazon$/ {
    class { '::selinux':
      mode => $selinux_mode,
    }

    $set_selinux_mode = $selinux_mode ? {
      'enforcing' => 'enforcing',
      /(permissive|disabled)/ => 'permissive',
    }

    # This exec will fail with the error "SELinux is disabled" if changing from diabled mode to any other mode without a reboot.
    exec { 'alter selinux':
      command => "/sbin/setenforce ${set_selinux_mode}",
      unless  => "/sbin/getenforce | /bin/grep -i ${selinux_mode}",
    }

    if $::selinux == true and $selinux_mode == 'disabled' {
      notify { 'selinux info':
        message =>"SELinux has been set to ${set_selinux_mode} mode but is configured for disabled mode. A reboot is required to disable SELinux.",
        require => Exec['alter selinux'],
      }
    } elsif $::selinux == false and $selinux_mode != 'disabled' {
      notify { 'selinux info':
        message =>"SELinux is currently disabled. A reboot is required to enable ${selinux_mode} mode.",
        before  => Exec['alter selinux'],
      }
    }

  } else {
    fail("Class['selinux']: Unsupported osfamily: ${::osfamily}")
  }

}
