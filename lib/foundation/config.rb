require 'etc'

require 'mixlib/config'
require 'net/ssh'

module Foundation
  class Config
    extend Mixlib::Config

    configure do |c|
      c[:root_dir] = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
      c[:domain] = 'example.com'
    end

    def self.path(relative_pathname)
      File.join(self[:root_dir], relative_pathname)
    end

    # Return array of config files present in the repository:
    # - config/basnename.ext
    # - config/basename-*.ext,
    # - .chef/basename.ext
    # - .chef/basename-*.ext
    def self.config_files(basename, ext='.rb')
      patterns = [ "config/#{basename}#{ext}",
                   "config/#{basename}-*#{ext}",
                   ".chef/#{basename}-*#{ext}" ]
      Dir[ *patterns.map { |fp| path(fp) } ]
    end

    def self.load!
      config_files('foundation').each { |cf| from_file(cf) }

      self[:username] ||=
        Net::SSH::Config.for("whatever.i.#{self[:domain]}")[:user] ||
        Etc.getlogin

      nil
    end

    # Load default configuration automagically
    self.load!
  end
end
