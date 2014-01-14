require 'etc'

require 'minigit'
require 'tinyconfig'

module Foundation
  class Config < TinyConfig
    option :root_dir,
           ::File.realpath(::File.join(::File.dirname(__FILE__), '..', '..'))
    option :domain
    option :email_domain, -> { domain }
    option :headquarters, -> { "headquarters.#{domain}" }
    option :email_regexp, -> { /@#{Regexp.escape(email_domain)}$/ }

    option :opscode_organization, nil
    option :opscode_username, -> { username }

    option :chef_server_url, -> {
      if opscode_organization
        "https://api.opscode.com/organization/#{opscode_organization}"
      else
        "https://chef.#{domain}"
      end
    }

    option :chef_username, -> {
      if opscode_organization
        opscode_username
      else
        username
      end
    }

    def self.load!
      $realm ||= self.new.load!
    end

    def load!
      config_files('foundation').
        each { |cfg_path| load(cfg_path) }
      self
    end

    def git
      @git ||= ::MiniGit.new(root_dir)
    end

    def username
      @username ||= git['user.email'].split('@').first
    end

    def path(relative_pathname)
      ::File.expand_path(relative_pathname, root_dir)
    end

    # Return array of config files present in the repository:
    # - config/basnename.ext
    # - config/basename/*.ext,
    # - config/basename-*.ext,
    # - .chef/basename/*.ext
    # - .chef/basename-*.ext
    def config_files(basename, ext='.rb')
      ::Enumerator.new do |out|
        [
          "lib/config/#{basename}#{ext}",
          "lib/config/#{basename}/*#{ext}",
          "config/#{basename}#{ext}",
          "config/#{basename}/*#{ext}",
          "config/#{basename}-*#{ext}",
          ".chef/#{basename}/*#{ext}",
          ".chef/#{basename}-*#{ext}"
        ].each do |glob|
          ::Dir[path(glob)].each do |file|
            out << ::File.realpath(file)
          end
        end
      end
    end

    def configure(other, basename, *skip_files)
      skip_files = skip_files.map { |sf| ::File.realpath(sf) }
      config_files(basename).each do |config_path|
        next if skip_files.include?(config_path)
        begin
          config = ::File.read(config_path)
        rescue => exception
          ::Kernel.warn "WARNING: can't read #{config_path}: #{exception}"
        else
          ::STDERR.puts "DEBUG: loading #{config_path}" if ::ENV['DEBUG']
          other.instance_eval(config, config_path)
        end
      end
    end
  end
end

Foundation::Config.load!
