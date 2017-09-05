#!/bin/bash

# This script will prepare a clean CentOS 7 machine for masterless Puppet 4.

# Bring the machine up to date.
#yum -y update

# Install the Puppet PC1 repo
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm

# Install the EPEL repo
yum install -y epel-release

# Install dependencies
yum install -y puppet-agent git figlet

# Install killer robots. Yes, you heard right.
/opt/puppetlabs/puppet/bin/gem install r10k

# Download required Puppet modules
cd /vagrant/puppet/
/opt/puppetlabs/puppet/bin/r10k puppetfile install

# Apply Puppet build
/opt/puppetlabs/puppet/bin/puppet apply --modulepath=/vagrant/puppet/modules:/vagrant/puppet/site --hiera_config=/vagrant/puppet/hiera.yaml /vagrant/puppet/manifests/site.pp
