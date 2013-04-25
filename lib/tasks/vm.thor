# -*- ruby -*-

require 'foundation/config'

class VM < Thor
  include Thor::Actions

  desc :up, "Bring up the VM environment"
  method_option :force, :aliases => '-f', :type => :boolean, :default => false
  def up
    run "vagrant up chef"
    %w(validator.pem webui.pem).each do |pem|
      pem_path = Foundation::Config.path(".chef/vm.#{pem}")
      if !File.exist?(pem_path) || options[:force]
        create_file pem_path do
          run "vagrant ssh chef -c 'sudo cat /etc/chef-server/chef-#{pem}'", :capture => true
        end
      else
        say_status :exists, relative_to_original_destination_root(pem_path), :blue
      end
    end

    pem_path = Foundation::Config.path(".chef/vm.client.pem")
    if !File.exist?(pem_path) || options[:force]
      knife 'client', 'create', '-u', 'chef-webui', '-k', Foundation::Config.path(".chef/vm.webui.pem"), '--admin', '-f', pem_path, '--disable-editing', 'chef-user'
    else
      say_status :exists, relative_to_original_destination_root(pem_path), :blue
    end

    with_vm_chef_server { thor 'repo:upload' }

    knife 'status'
  end

  desc :destroy, "Bring down the VM environment"
  def destroy
    run "vagrant destroy -f"
    Dir['.chef/vm.*.pem'].each { |f| remove_file f }
  end

  desc :knife, 'Run a Knife command against VM setup'
  def knife(command, *args)
    say_status :knife, "#{command} #{args.join(' ')}"
    system( { 'VM_CHEF_SERVER' => '1' }, 'knife', *(command.split), *args )
  end

  no_tasks do
    def with_vm_chef_server
      orig_vm_chef_server, ENV['VM_CHEF_SERVER'] = ENV['VM_CHEF_SERVER'], '1'
      yield
    ensure
      ENV['VM_CHEF_SERVER'] = orig_vm_chef_server
    end
  end
end
