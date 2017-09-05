#!/bin/bash

# Run this script to do a single run of Puppet.

# Apply Puppet build
/bin/sudo /opt/puppetlabs/puppet/bin/puppet apply --modulepath=/vagrant/puppet/modules:/vagrant/puppet/site --hiera_config=/vagrant/puppet/hiera.yaml /vagrant/puppet/manifests/site.pp
