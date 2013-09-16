chef_gem 'chef-rewind'
require 'chef/rewind'

include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_ssl'
include_recipe 'docker'
include_recipe 'postfix'

include_recipe 'jenkins::server'
include_recipe 'jenkins::proxy'

group 'docker::jenkins' do
  group_name 'docker'
  members ['jenkins']
  append true
end

remote_directory "/srv/jenkins/site-files" do
  owner 'root'
  group 'jenkins'
  mode '0755'
  files_owner 'root'
  files_group 'jenkins'
  files_mode '0644'
  purge true
end

# needed for the backup script
include_recipe 'perl'
package 'libxml-simple-perl'
package 'libwww-perl'
cookbook_file '/usr/share/jenkins/backup.pl' do
  mode '0755'
end

[
  "#{node[:apache][:dir]}/sites-available/jenkins",
  "/etc/default/jenkins"
].each do |path|
  rewind "template[#{path}]" do
    cookbook 'jenkins-app'
  end
end

directory '/srv/bacula/backup/jenkins' do
  owner 'jenkins'
  group 'jenkins'
  recursive true
end

include_recipe 'jenkins-app::builder'
