# -*- mode: ruby -*-
# vi: set ft=ruby :

TLD = 'vm'
SUBNET = '192.168.23'
CONFIGURE_DEFAULTS = { file_cache_path: '/vagrant/cache' }

Vagrant.require_plugin 'vagrant-hostmanager'

require 'shellwords'

def configure(*args)
  opts = CONFIGURE_DEFAULTS.merge( args.last.is_a?(Hash) ? args.pop : {} )
  cmd = 'set -x ; /vagrant/config/bootstrap/configure'
  args.each { |arg|      cmd << " #{Shellwords.escape(arg.to_s)}" }
  opts.each { |key, val| cmd << " #{key.to_s.upcase}=#{Shellwords.escape(val.to_s)}" if val }
  cmd << ' && ./bootstrap.sh'
end

Vagrant.configure("2") do |config|
  config.vm.box = "precise-server-cloudimg64-current"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.define :chef do |node|
    node.vm.hostname = 'chef.vm'
    node.hostmanager.aliases = ['chef']
    node.vm.network :private_network, ip: "#{SUBNET}.5"
    node.vm.provider "virtualbox" do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", 1024]
    end
    node.vm.provision :shell, :inline => configure('--with-chef-server', name: 'chef', fqdn: 'chef.vm')
  end

  config.vm.define :node do |node|
    node.vm.hostname = 'node.vm'
    node.hostmanager.aliases = ['node']
    node.vm.network :private_network, ip: "#{SUBNET}.11"
    node.vm.provision :shell, :inline => configure(chef_server_url: "https://chef.vm/", name: 'node', run_list: 'role[__base]', validation_key: '/vagrant/.chef/vm.validator.pem')
  end
end
