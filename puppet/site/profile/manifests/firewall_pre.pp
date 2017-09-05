class profile::firewall_pre {
  Firewall {
    require => undef,
  }
  # Default firewall rules
  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }->
  firewall { '003 accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '004 accept related established rules':
    chain  => 'OUTPUT',
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }->
  firewall { '200 allow outgoing icmp type 8 (ping)':
    chain  => 'OUTPUT',
    proto  => 'icmp',
    icmp   => 'echo-request',
    action => 'accept',
  }->
  firewall { '200 allow outgoing dns lookups':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '53',
    proto  => 'udp',
    action => 'accept',
  }->
  firewall { '200 allow outgoing ntp requests':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '123',
    proto  => 'udp',
    action => 'accept',
  }->
  firewall { '200 allow outgoing puppet master':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
  }->
  firewall { '200 allow outgoing http':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '80',
    proto  => 'tcp',
    action => 'accept',
  }->
  firewall { '200 allow outgoing https':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '443',
    proto  => 'tcp',
    action => 'accept',
  }
}
