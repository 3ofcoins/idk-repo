# -*- ruby -*-

class Repo < Thor
  include Thor::Actions

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
      system 'knife', *(command.split), *args or abort
    end
  end
end
