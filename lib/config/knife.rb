## Main configuration for Knife, the command line Chef API client.
##
## It should be symlinked as .chef/knife.rb.
##
## Put your local knife configuration in config/knife-whatever.rb if
## you want to commit it into repository, or .chef/knife-whatever.rb
## if it's a secret (say, AWS access keys).

_lib_dir = File.realpath(File.dirname(File.dirname(File.realpath(__FILE__))))
$:.unshift(_lib_dir) unless $:.include?(_lib_dir)

# Load Foundation configuration
require 'foundation/config'
_cfg = Foundation::Config

# Default configuration
log_level                :debug
log_location             STDOUT
if ENV['VM_CHEF_SERVER']
  node_name                'chef-user'
  client_key               _cfg.path(".chef/vm.client.pem")
  validation_client_name   "chef-validator"
  validation_key           _cfg.path(".chef/vm.validator.pem")
  chef_server_url          "https://#{_cfg[:vm][:chef][:ip]}"
elsif _cfg[:opscode_organization]
  node_name                _cfg[:opscode_username] || _cfg[:chef_username] || _cfg[:username]
  client_key               _cfg.path(".chef/#{node_name}.pem")
  validation_client_name   "#{_cfg[:opscode_organization]}-validator"
  validation_key           _cfg.path(".chef/#{_cfg[:opscode_organization]}-validator.pem")
  chef_server_url          "https://api.opscode.com/organizations/#{_cfg[:opscode_organization]}"
else
  node_name                _cfg[:chef_username] || _cfg[:username]
  client_key               _cfg.path('.chef/client.pem')
  validation_client_name   "chef-validator"
  validation_key           _cfg.path(".chef/validation.pem")
  chef_server_url          _cfg[:chef_server_url] || "https://chef.i.#{_cfg[:domain]}"
end
cache_type               'BasicFile'
cache_options            :path => "#{ENV['HOME']}/.chef/checksums"
cookbook_path            [ _cfg.path('cookbooks'),
                           _cfg.path('lib/cookbooks'),
                           _cfg.path('vendor/cookbooks') ]
verbosity                0

knife[:distro] = 'chef-full'

# Load custom configuration
_cfg.config_files('knife').each do |config_path|
  Kernel::eval( File.read(config_path), binding, config_path )
end
