require 'chef'
require 'chef/knife'
require 'rake'

module KnifeTask

  Rake::TaskManager.record_task_metadata = true

  def load_rake_as_lib
    Dir.chdir(Chef::Config.find_chef_repo_path(__FILE__))
    if Rake.application.tasks.empty?
      Rake.application.init
      Rake.application.options.rakefile = 'config/tasks.rb'
      Rake.application.load_rakefile
    end
  end

  class Do < Chef::Knife
    include KnifeTask
    banner 'knife do (options)'

    deps do
      require 'rake'
    end

    def run
      load_rake_as_lib
      Rake.application.tasks.each { |t| p "#{t.name} # #{t.comment}" }
    end
  end

  class DoTask < Chef::Knife
    include KnifeTask
    banner 'knife do task (options)'

    deps do
      require 'rake'
    end

    option :all,
           short: '-A',
           long: '--all',
           description: 'Run all Rake tasks.',
           proc: Proc.new { Rake.application.tasks.each { |t| Rake::Task[t.name].invoke } }

    option :verbose,
           short: '-v',
           long: '--verbose',
           description: 'Log message to standard output.',
           proc: Proc.new { Kernel.system('rake --rakefile config/tasks.rb --verbose') }

    # Options Rake magically captures from the command line.
    # Defined here so they're returned by `knife do task --help`
    option :execute_continue,
           short: '-E CODE',
           description: 'Execute some Ruby code, then continue with normal task processing.'

    option :execute_code,
           short: '-e CODE',
           description: 'Execute some Ruby code and exit.'

    option :version,
           short: '-V',
           description: 'Display Rake version.'

    option :dry_run,
           short: '-n',
           description: 'Do a dry run without executing actions.'

    option :execute_print,
           short: '-p',
           description: 'Execute some Ruby code, print the result, then exit.'

    option :silent,
           short: '-s',
           description: 'Do not log messages to standard output.'

    option :rakefile,
           short: '-f FILENAME',
           description: 'Use FILENAME as the rakefile to search for.'

    def run
      load_rake_as_lib
      if ARGV.drop(2).empty?
        Rake::Task[:default].invoke
      else
        ARGV.drop(2).each { |t| Rake::Task[t].invoke }
      end
    end
  end
end
