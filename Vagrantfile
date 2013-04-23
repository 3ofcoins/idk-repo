# -*- mode: ruby -*-
# vi: set ft=ruby :

TLD = 'vm'
SUBNET = '192.168.23'

Vagrant.require_plugin 'vagrant-omnibus'

Vagrant.configure("2") do |config|
  config.vm.box = "precise-server-cloudimg64-current"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  config.omnibus.chef_version = '11.4.0'

  config.vm.define :chef do |vm_config|
    vm_config.vm.network :private_network, ip: "#{SUBNET}.5"
    vm_config.vm.provider "virtualbox" do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", 1024]
    end
  end
end
