## Main configuration for Knife, the command line Chef API client.
##
## It is symlinked as .chef/knife.rb.

libdir = File.dirname(File.dirname(File.realpath(__FILE__)))
$:.unshift(libdir) unless $:.include?(libdir)
require 'foundation/config'

# Default configuration
log_level                :debug
log_location             STDOUT
chef_server_url          $realm.chef_server_url
node_name                $realm.chef_username
client_key               $realm.path('.chef/client.pem')
validation_client_name   "#{$realm.opscode_organization || 'chef-'}-validator"
cache_type               'BasicFile'
cache_options            :path => $realm.path(".chef/checksums")
cookbook_path            [ $realm.path('cookbooks'),
                           $realm.path('lib/cookbooks'),
                           $realm.path('vendor/cookbooks') ]

knife[:distro] = 'chef-full'

# Load custom configuration
$realm.config_files('knife').each do |config_path|
  begin
    Kernel::eval( File.read(config_path), binding, config_path )
  rescue => e
    warn "WARNING: #{config_path}: #{e}"
  end
end
