# -*- mode: ruby -*-
# vi: set ft=ruby :

TLD = 'vm'
SUBNET = '192.168.23'
BOOTSTRAP_DEFAULTS = {
  file_cache_path: '/vagrant/cache',
  foundation_root: '/vagrant',
  run_list: 'role[__base]',
  chef_server_url: "https://#{SUBNET}.5/",
  validation_key: '/vagrant/.chef/vm.validator.pem'
}

require 'shellwords'
def _define(config, name, ip, *bootstrap_args, &block)
  bootstrap_cmd  = 'set -x ; /vagrant/config/bootstrap/bootstrap --'
  bootstrap_opts = BOOTSTRAP_DEFAULTS.merge( bootstrap_args.last.is_a?(Hash) ? bootstrap_args.pop : {} )
  bootstrap_opts[:name] ||= name
  bootstrap_args.each { |arg|      bootstrap_cmd << " #{Shellwords.escape(arg.to_s)}" }
  bootstrap_opts.each { |key, val| bootstrap_cmd << " #{key.to_s.upcase}=#{Shellwords.escape(val.to_s)}" if val }

  config.vm.define name do |node|
    node.vm.hostname = "#{name}.#{TLD}"
    node.vm.network :private_network, ip: "#{SUBNET}.#{ip}"
    node.vm.provision :shell, inline: bootstrap_cmd
    block.call(node) if block
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "precise-server-cloudimg64-current"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  _define(config, :chef, 5, '--with-chef-server', server_fqdn: "#{SUBNET}.5", run_list: nil, validation_key: nil) do |node|
    node.vm.provider "virtualbox" do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", 1024]
    end
  end
  _define(config, :node, 11)
  _define(config, :lenny, 12) { |node| node.vm.box = 'debian-lenny-32-chef' }
end
