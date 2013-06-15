# -*- ruby -*-

class Repo < Thor
  include Thor::Actions

  desc :setup, "Initialize the repository"
  method_option :python, :default => "python"
  method_option :clean, :aliases => '-c', :type => :boolean, :default => false
  def setup
    thor('repo:clean') if options[:clean]
    create_link '.chef/knife.rb', '../lib/config/knife.rb', :force => true

    chmod '.chef', 0700, :verbose => false
    inside '.chef' do
      Dir['*.pem', '*.secret', '*.rb'].each do |f|
        chmod f, 0600, :verbose => false
      end
    end
  end

  desc :clean, "Clean the repository"
  def clean
    remove_dir ".chef"
  end

  desc :upload, "Upload everything to the Chef server"
  def upload
    knife 'cookbook upload', '--all'

    Dir['roles/*.rb', 'roles/*.json'].each do |f|
      knife 'role from file', f
    end

    Dir['environments/*.rb', 'environments/*.json'].each do |f|
      knife 'environment from file', f
    end

    Dir['data_bags/*'].select { |d| File.directory?(d) }.each do |d|
      knife 'data bag create', File.basename(d)
    end

    knife 'data', 'bag', 'from', 'file', '--all'
  end

  no_tasks do
    def knife(command, *args)
      say_status :knife, "#{command} #{args.join(' ')}"
      system 'knife', *(command.split), *args
    end
  end
end
