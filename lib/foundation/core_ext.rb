module Foundation
  module ConfigureMixin
    def instance_load_pieces(basename=nil)
      caller = ::Kernel.caller.first.sub(/(:\d+)?(:in .*)?$/, '')
      basename ||= ::File.basename(caller, '.rb')
      $realm.configure(self, basename, caller)
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
