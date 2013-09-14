# Sanitize Chef client's environment

include_recipe 'chef-client::config'
include_recipe 'sanitize::filesystem' # creates `file_cache_path`

# Update Omnibus Chef client
include_recipe 'omnibus_updater'

# Lock down log that may be created with insufficient permissions
file "/var/log/chef/client.log" do
  mode "0600"
  only_if { File.exists?('/var/log/chef/client.log') }
end
