begin
  require 'foundation/config'
rescue LoadError
  if ENV['NESTING_SENTINEL']
    # Fake config to let rest of Vagrantfile load.
    module Foundation
      module Config
        def self.[](k)
          return self
        end
      end
    end
  else
    ENV['NESTING_SENTINEL'] = '1'
    puts "*** Can't require 'foundation/config'. Trying to install mixlib-config in vagrant..."
    system 'set -x ; vagrant gem install mixlib-config'
    puts "*** Done. Now try again."
    exit 1
  end
end
