# -*- ruby -*-

class Repo < Thor
  include Thor::Actions

  desc :setup, "Initialize the repository"
  method_option :python, :default => "python"
  def setup
    if File.exists? 'vendor/root/bin/python'
      say_status :exists, 'Python virtualenv', :green
    else
      run "#{options[:python]} vendor/virtualenv/virtualenv.py vendor/root"
    end

    run "vendor/root/bin/pip install -r vendor/requirements.txt"
  end

  desc :clean, "Clean the repository"
  def clean
    remove_dir "vendor/root"
  end

end
