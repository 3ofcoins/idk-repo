# Prerequisites needed to run the builds

require 'shellwords'

include_recipe 'build-essential'
include_recipe 'git'

node['jenkins']['git'].each do |var, value|
  execute "git config #{var}" do
    command "git config --global #{Shellwords.escape(var)} #{Shellwords.escape(value)}"
    user 'jenkins'
    group 'jenkins'
    environment 'HOME' => '/srv/jenkins'
    not_if do
      cmd = Mixlib::ShellOut.new(
        'git', 'config', '--global', var,
        user: 'jenkins',
        group: 'jenkins',
        environment: { 'HOME' => '/srv/jenkins' },
        returns: [0, 1])
      cmd.run_command
      cmd.error!
      cmd.stdout.strip == value
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'builder-*.rb')].each do |subrecipe|
  subrecipe = File.basename(subrecipe, '.rb')
  include_recipe "#{cookbook_name}::#{subrecipe}"
end
