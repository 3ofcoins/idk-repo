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

# Default configuration
log_level                :info
log_location             STDOUT
if _cfg[:opscode_organization]
  node_name                _cfg[:opscode_username] || _cfg[:chef_username] || _cfg[:username]
  client_key               _cfg.path(".chef/#{node_name}.pem")
  validation_client_name   "#{_cfg[:opscode_organization]}-validator"
  validation_key           _cfg.path(".chef/#{_cfg[:opscode_organization]}-validator.pem")
  chef_server_url          "https://api.opscode.com/organizations/#{_cfg[:opscode_organization]}"
else
  node_name                _cfg[:username]
  client_key               _cfg.path('.chef/client.pem')
  validation_client_name   "chef-validator"
  validation_key           _cfg.path(".chef/validation.pem")
  chef_server_url          "http://chef.i.#{_cfg[:domain]}:4000"
end
cache_type               'BasicFile'
cache_options            :path => "#{ENV['HOME']}/.chef/checksums"
cookbook_path            [ _cfg.path('cookbooks'),
                           _cfg.path('lib/cookbooks'),
                           _cfg.path('vendor/cookbooks') ]
verbosity                0

knife[:ssh_user] = _cfg[:username]
knife[:distro] = 'chef-full'

# Load custom configuration
_cfg.config_files('knife').each do |config_path|
  Kernel::eval( File.read(config_path), binding, config_path )
end
