#!/bin/bash

# Set up the Puppet Master
vagrant ssh puppet -c "sudo service iptables stop; \
sudo puppet module install puppetlabs/puppetdb; \
sudo puppet module install puppetlabs/ntp; \
sudo puppet module install puppetlabs/firewall; \
sudo puppet module install puppetlabs/mysql --version 0.6.1; \
sudo puppet module install puppetlabs/openstack; \
sudo puppet module install puppetlabs/mongodb; \
cd /etc/puppet/modules; \
sudo tar -xvzf /vagrant/*gz; \
sudo rm -rf havana
sudo mv puppetlabs-havana* havana; \
sudo cp /vagrant/site.pp /etc/puppet/manifests/site.pp; \
sudo chown root:puppet /etc/puppet/manifests/site.pp; \
sudo cp /vagrant/hiera.yaml /etc/puppet/hiera.yaml; \
sudo chown root:puppet /etc/puppet/hiera.yaml; \
sudo mkdir /etc/puppet/hieradata; \
sudo chown root:puppet /etc/puppet/hieradata; \
sudo cp /etc/puppet/modules/havana/examples/common.yaml /etc/puppet/hieradata/common.yaml; \
sudo chown root:puppet /etc/puppet/hieradata/common.yaml; \
sudo service puppetmaster start;\
sudo puppet agent -t; \
sudo puppet apply --modulepath /etc/puppet/modules -e \"class { '::puppetdb': listen_address => '0.0.0.0', ssl_listen_address => '0.0.0.0' } class { 'puppetdb::master::config': puppetdb_server => 'puppet'}\""
