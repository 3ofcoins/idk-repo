# -*- mode: ruby -*-
# vi: set ft=ruby :

TLD = 'vm'
SUBNET = '192.168.23'

Vagrant.require_plugin 'vagrant-omnibus'

# libdir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
# $:.unshift(libdir) unless $:.include?(libdir)
# require 'foundation/vagrant'

Vagrant.configure("2") do |config|
  config.vm.box = "precise-server-cloudimg64-current"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  config.omnibus.chef_version = '11.4.0'

  config.vm.define :chef do |vm_config|
    vm_config.vm.network :private_network, ip: "#{SUBNET}.5"
    vm_config.vm.provider "virtualbox" do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", 1024]
    end
    vm_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = %w(cookbooks vendor/cookbooks)
      chef.add_recipe 'hostname'
      chef.add_recipe 'chef-server'
      chef.json = {
        set_fqdn: "chef.#{TLD}",
        chef_server: {
          configuration: {
            chef_server_webui: { enable: false }
          }}}
    end
  end
end
