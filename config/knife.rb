## Main configuration for Knife, the command line Chef API client.
##
## It should be symlinked as .chef/knife.rb.
##
## Put your local knife configuration in config/knife-whatever.rb if
## you want to commit it into repository, or .chef/knife-whatever.rb
## if it's a secret (say, AWS access keys).

# Load Foundation configuration
require 'foundation/config'
_cfg = Foundation::Config

log_level                :info
log_location             STDOUT
node_name                _cfg[:username]
client_key               _cfg.path(".chef/client.pem")
validation_client_name   "chef-validator"
validation_key           _cfg.path(".chef/validation.pem")
chef_server_url          "http://chef.i.#{_cfg[:domain]}:4000"
cache_type               'BasicFile'
cache_options            :path => "#{ENV['HOME']}/.chef/checksums"
cookbook_path            [ _cfg.path('cookbooks'),
                           _cfg.path('lib/cookbooks'),
                           _cfg.path('vendor/cookbooks') ]
verbosity                0

knife[:ssh_user] = _cfg[:username]
knife[:distro] = 'chef-full'

Dir[ File.join(_cfg[:root_dir], 'config', 'knife-*.rb'),
     File.join(_cfg[:root_dir], '.chef',  'knife-*.rb') ].each do |config_path|
  begin
    # Suppress redefined constant warnings - this may be loaded
    # multiple times via Ginza::Cloud
    orig_verbose, $VERBOSE = $VERBOSE, nil
    Kernel::eval( File.read(config_path), binding, config_path )
  ensure
    $VERBOSE = orig_verbose
  end
end
