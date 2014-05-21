require 'chef'
require 'chef/knife'
require 'rake'

module KnifeTask
  def load_rake_as_lib
    Dir.chdir(Chef::Config.find_chef_repo_path(__FILE__))
    if Rake.application.tasks.empty?
      Rake.application.init
      Rake.application.options.rakefile = 'config/tasks.rb'
      Rake.application.load_rakefile
    end
  end

  def run
    load_rake_as_lib
    # Rake.application.tasks.each { |t| p t.name }
    Kernel.system("rake --rakefile config/tasks.rb -T")
  end

  class Do < Chef::Knife
    include KnifeTask

    deps do
      require 'rake'
    end

    banner 'knife do (options)'

    option :test_option,
           short: '-E',
           long: '--test',
           description: 'Test option',
           proc: proc { p 'test' }
  end

  class DoTask < Chef::Knife
    include KnifeTask

    deps do
      require 'rake'
    end

    banner 'knife do task (options)'

    option :all,
           long: '--all',
           description: 'Run all Rake tasks.',
           proc: proc { Kernel.system('rake --rakefile config/tasks.rb') }
           # Rake.application.run

    option :verbose,
           long: '--verbose',
           description: 'Log message to standard output.',
           proc: proc { Kernel.system('rake --rakefile config/tasks.rb --verbose') }
           # Rake.application.options.verbose
  end
end
