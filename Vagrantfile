# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "selenium" do |selenium|
    selenium.vm.box = "centos7"
    selenium.vm.box_url = "http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7.box"

    selenium.vm.hostname = "selenium-grid.local"

    #selenium.vm.network "forwarded_port", guest: 4444, host: 4444
    #selenium.vm.network "forwarded_port", guest: 5900, host: 5900
    selenium.vm.network :private_network, ip: "10.11.12.13"

    selenium.vm.synced_folder ".", "/vagrant",
    :nfs => true,
    id: "shared"

    selenium.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--chipset", "ich9"]
    end
    selenium.vm.provision "shell", inline: "/bin/bash /vagrant/bootstrap.sh"
  end


  config.vm.define "planet4" do |planet4|
    planet4.vm.box = "centos7"
    planet4.vm.box_url = "http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7.box"

    planet4.vm.hostname = "planet4.local"

    #planet4.vm.network "forwarded_port", guest: 80, host: 80
    #planet4.vm.network "forwarded_port", guest: 3306, host: 3306
    #planet4.vm.network "forwarded_port", guest: 4444, host: 4444
    #planet4.vm.network "forwarded_port", guest: 5900, host: 5900
    planet4.vm.network :private_network, ip: "10.11.12.13"

    planet4.vm.synced_folder ".", "/vagrant",
    :nfs => true,
    id: "shared"

    planet4.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--chipset", "ich9"]
    end
    planet4.vm.provision "shell", inline: "/bin/bash /vagrant/bootstrap.sh"
  end

end
