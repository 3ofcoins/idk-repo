require 'chef'
require 'chef/knife'
require 'rake'

module Rake
  class << self
    def application
      @application ||= CustomApplication.new
    end
  end

  class CustomApplication < Application
    DEFAULT_RAKEFILES = ['config/tasks.rb'].freeze

    def initialize
      super
      @name = 'rake'
      @rakefiles = DEFAULT_RAKEFILES.dup
      @rakefile = nil
      @pending_imports = []
      @imported = []
      @loaders = {}
      @default_loader = Rake::DefaultLoader.new
      @original_dir = Dir.pwd
      @top_level_tasks = []
      add_loader('rb', Rake::DefaultLoader.new)
      add_loader('rf', Rake::DefaultLoader.new)
      add_loader('rake', Rake::DefaultLoader.new)
      @tty_output = STDOUT.tty?
      @terminal_columns = ENV['RAKE_COLUMNS'].to_i
    end
  end
end

module KnifeTasks
  include Rake

  Rake::TaskManager.record_task_metadata = true

  def load_rake_as_lib
    Dir.chdir(Chef::Config.find_chef_repo_path(__FILE__))
    if Rake.application.tasks.empty?
      Rake.application.init
      Rake.application.load_rakefile
    end
  end

  class Do < Chef::Knife
    include KnifeTasks
    banner 'knife do (options)'

    deps do
      require 'rake'
    end

    option :trace,
           short: '-t',
           long: '--trace=[OUT]',
           description: "Turn on invoke/execute tracing, enable full backtrace. OUT can be stderr (default) or stdout."

    def run
      load_rake_as_lib
      Rake.application.tasks.each { |t| p "#{t.name} # #{t.comment}" }
    end
  end

  class DoTask < Chef::Knife
    include KnifeTasks
    banner 'knife do task (options)'

    deps do
      require 'rake'
    end

    # Options Rake magically captures from the command line. Defined here
    # based on `rake -h` so they're returned by `knife do task --help`.
    option :execute_continue,
           short: '-E CODE',
           long: '--execute-continue CODE',
           description: 'Execute some Ruby code, then continue with normal task processing.'

    option :execute_code,
           short: '-e CODE',
           long: '--execute-code CODE',
           description: 'Execute some Ruby code and exit.'

    option :version,
           short: '-V',
           long: '--version',
           description: 'Display Rake version.'

    option :dry_run,
           short: '-n',
           long: '--dry-run',
           description: 'Do a dry run without executing actions.'

    option :execute_print,
           short: '-p CODE',
           long: '--execute-print CODE',
           description: 'Execute some Ruby code, print the result, then exit.'

    option :silent,
           short: '-s',
           long: '--silent',
           description: "Like --quiet, but also suppresses the 'in directory' announcement."

    option :quiet,
           short: '-q',
           long: '--quiet',
           description: 'Do not log messages to standard output.'

    option :rakefile,
           short: '-f FILENAME',
           long: '--rakefile FILENAME',
           description: 'Use FILENAME as the rakefile to search for.'

    option :no_deprecation_warnings,
           short: '-X',
           long: '--no-deprecation-warnings',
           description: 'Disable the deprecation warnings.'

    option :system,
           short: '-g',
           long: '--system',
           description: "Using system wide (global) rakefiles (usually '~/.rake/*.rake')."

    option :no_system,
           short: '-G',
           long: '--no-system',
           long: '--nosystem',
           description: 'Use standard project Rakefile search paths, ignore system wide rakefiles.'

    option :trace,
           short: '-t',
           long: '--trace=[OUT]',
           description: "Turn on invoke/execute tracing, enable full backtrace. OUT can be stderr (default) or stdout."

    option :rules,
           long: '--rules',
           description: 'Trace the rules resolution.'

    option :libdir,
           short: '-I LIBDIR',
           long: '--libdir LIBDIR',
           description: 'Include LIBDIR in the search path for required modules.'

    option :require,
           short: '-r MODULE',
           long: '--require MODULE',
           description: 'Require MODULE before executing rakefile.'

    option :suppress_backtrace,
           long: '--suppress-backtrace PATTERN',
           description: 'Suppress backtrace lines matching regexp PATTERN. Ignored if --trace is on.'

    option :rakelib,
           short: '-R RAKELIBDIR',
           long: '--rakelibdir RAKELIBDIR',
           long: '--rakelib RAKELIBDIR',
           description: "Auto-import any .rake files in RAKELIBDIR. (default is 'rakelib')"

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
