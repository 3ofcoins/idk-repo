## Main configuration for Knife, the command line Chef API client.
##
## It is symlinked as .chef/knife.rb.

libdir = File.dirname(File.dirname(File.realpath(__FILE__)))
$:.unshift(libdir) unless $:.include?(libdir)
require 'idk/config'

# Default configuration
log_level                :debug
log_location             STDOUT
chef_server_url          $realm.chef_server_url
node_name                $realm.chef_username
client_key               $realm.path('.chef/client.pem')
validation_client_name   "#{$realm.opscode_organization || 'chef'}-validator"
validation_key           $realm.path('config/validator.pem')
cache_type               'BasicFile'
cache_options            :path => $realm.path(".chef/checksums")
cookbook_path            [ $realm.path('cookbooks'),
                           $realm.path('lib/cookbooks'),
                           $realm.path('vendor/cookbooks') ]

knife[:distro] = 'chef-full'

class Lazy < Delegator
  def initialize(&block) ; @delegate_sd_block = block ; end
  def __getobj__ ; @delegate_sd_obj ||= @delegate_sd_block.call ; end
end
def Lazy(&block) ; Lazy.new(&block) ; end

knife[:vault_mode] = 'client'
knife[:vault_admins] = Lazy {
  Chef::User
    .list
    .keys
    .select { |uname| uname != 'admin' && Chef::User.load(uname).admin }
}

instance_load_config_pieces
