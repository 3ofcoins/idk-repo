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

    def self.from_file(filename)
      super
      self[:username] ||=
        Net::SSH::Config.for(self[:domain])[:user] ||
        Etc.getlogin
      self
    end

    def self.path(relative_pathname)
      File.join(self[:root_dir], relative_pathname)
    end

    # Load default configuration automagically
    self.from_file(File.join(self[:root_dir], 'config', 'foundation.rb'))
  end
end
