# -*- ruby -*-

class Repo < Thor
  include Thor::Actions

  desc :setup, "Initialize the repository"
  method_option :python, :default => "python"
  method_option :clean, :aliases => '-c', :type => :boolean, :default => false
  def setup
    thor('repo:clean') if options[:clean]

    if File.exists? 'vendor/root/bin/python'
      say_status :exists, 'Python virtualenv', :green
    else
      run "#{options[:python]} vendor/virtualenv/virtualenv.py vendor/root"
    end

    run "vendor/root/bin/pip install -q -r vendor/requirements.txt"

    create_link '.chef/knife.rb', '../lib/config/knife.rb', :force => true
    # create_link '.chef/plugins/knife', '../../lib/knife', :force => true

    chmod '.chef', 0700, :verbose => false
    inside '.chef' do
      Dir['*.pem', '*.secret', '*.rb'].each do |f|
        chmod f, 0600, :verbose => false
      end
    end
  end

  desc :clean, "Clean the repository"
  def clean
    remove_dir "vendor/root"
    remove_dir ".chef"
  end

end
