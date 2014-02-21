module Foundation
  module ConfigureMixin
    def instance_load_config_pieces(basename=nil)
      caller = ::Kernel.caller.first.sub(/(:\d+)?(:in .*)?$/, '')
      basename ||= ::File.basename(caller, '.rb')
      $realm.configure(self, basename, caller)
    end

    def instance_load(path)
      caller = ::Kernel.caller.first.sub(/(:\d+)?(:in .*)?$/, '')
      path = ::File.expand_path(path, ::File.dirname(caller))
      self.instance_eval(::File.read(path), path)
    end

    def instance_load_subdir
      caller = ::Kernel.caller.first.sub(/(:\d+)?(:in .*)?$/, '')
      glob = ::File.join(::File.dirname(caller),
        ::File.basename(caller, '.rb'), '*.rb')
      ::Dir[glob].sort.each do |subconf|
        instance_load(::File.expand_path(subconf))
      end
    end
  end
end

module Kernel
  include Foundation::ConfigureMixin
end

if defined?(Chef::Config)
  class Chef::Config
    class << self
      include Foundation::ConfigureMixin
    end
  end
end

if defined? Chef::Role
  class Chef::Role
    include Foundation::ConfigureMixin
  end
end

if defined? Chef::Environment
  class Chef::Environment
    include Foundation::ConfigureMixin
  end
end

if defined? Chef::Cookbook::Metadata
  class Chef::Cookbook::Metadata
    include Foundation::ConfigureMixin
  end
end
