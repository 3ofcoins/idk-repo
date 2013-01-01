# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'foundation/config'

Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.define :chef do |chef_config|
    chef_config.vm.network :hostonly, Foundation::Config[:vm][:chef][:ip]
    chef_config.vm.provision :shell, :inline => '/vagrant/lib/script/chef-server-bootstrap.sh'
  end
end
