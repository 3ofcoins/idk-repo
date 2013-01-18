# -*- mode: ruby -*-
# vi: set ft=ruby :

libdir = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
$:.unshift(libdir) unless $:.include?(libdir)

require 'foundation/vagrant_config'

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.define :chef do |chef_config|
    chef_config.vm.network :hostonly, Foundation::Config[:vm][:chef][:ip]
    chef_config.vm.provision :shell, :inline => '/vagrant/lib/script/chef-server-bootstrap.sh'
  end
end
