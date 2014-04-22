#
# Cookbook Name:: af_databackend
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if Chef::Config[:solo]
  Chef::Application.fatal!("Please set af.databackend.postgresql_password attribute!") unless node['af']['databackend']['postgresql_password']
else
  ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  node.set_unless['af']['databackend']['postgresql_password'] = secure_password
  node.save
end

include_recipe 'git'
include_recipe 'nginx'
include_recipe 'database::postgresql'
include_recipe 'postgresql::server'
include_recipe 'runit'
include_recipe 'rvm::system_install'

rvm_ruby node['af']['databackend']['ruby']

users_manage 'sysadmin::afdb' do
  search_group 'sysadmin'
  group_name 'afdb'
  group_id 901
end

user 'afdb' do
  group 'afdb'
  home '/srv/afdatabackend'
  shell '/bin/false'
end

db_conn = {
  :host     => 'localhost',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database_user 'afdb' do
  connection db_conn
  password   node['af']['databackend']['postgresql_password']
end

postgresql_database 'afdb' do
  connection db_conn
  owner 'afdb'
  encoding 'utf8'
end

directory "/srv/afdatabackend" do
  owner 'root'
  group 'sysadmin'
  mode '0775'
  recursive true
end

directory '/srv/afdatabackend/shared/config' do
  recursive true
end

%w[log var public/uploads public/rollback].each do |runtime_writable|
  directory "/srv/afdatabackend/shared/#{runtime_writable}" do
    owner 'root'
    group 'afdb'
    mode '0770'
    recursive true
  end
end

%w[repo shared/bundle shared/bin releases].each do |deploy_writable|
  directory "/srv/afdatabackend/#{deploy_writable}" do
    owner 'root'
    group 'sysadmin'
    mode '0775'
    recursive true
  end
end

file "/srv/afdatabackend/revisions.log" do
  owner 'root'
  group 'sysadmin'
  mode '0660'
end

template '/srv/afdatabackend/shared/config/database.yml' do
  owner 'root'
  group 'afdb'
  mode '0640'
end

file '/srv/afdatabackend/shared/config/secrets.yml' do
  owner 'root'
  group 'afdb'
  mode '0640'
  content YAML.dump('production' => Hash[node['af']['databackend']['secrets'].to_hash.sort])
end

if node['af']['databackend']['env_vault_item_id']
  chef_gem 'chef-vault' do
    version '~> 2.2'
  end
  require 'chef-vault'
  item = ChefVault::Item
    .load('creds', node['af']['databackend']['env_vault_item_id'])
  afdb_env = item
    .to_hash
    .sort
    .map { |k, v| "#{k}=#{v}\n" unless %w[chef_type data_bag id].include?(k) }
    .join
else
  afdb_env = ""
end

file '/srv/afdatabackend/shared/.env' do
  owner 'root'
  group 'afdb'
  mode '0640'
  content afdb_env
end

# FIXME: separate nginx cookbook
file '/etc/nginx/conf.d/ssl.conf' do
  content <<EOF
ssl_session_cache   shared:SSL:10m;
ssl_session_timeout 10m;
ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
ssl_ciphers AES128-GCM-SHA256:ECDHE-RSA-AES128-SHA256:RC4:HIGH:!MD5:!aNULL:!EDH;
ssl_prefer_server_ciphers on;
EOF
  owner 'root'
  group 'www-data'
  mode '0640'
end

template "#{node['nginx']['dir']}/sites-available/afdatabackend" do
  source 'nginx-site.erb'
  group node['nginx']['group']
  mode '0640'
  notifies :reload, 'service[nginx]' if ::File.exists?("#{node['nginx']['dir']}/sites-enabled/afdatabackend")
end

nginx_site "afdatabackend"

runit_service 'afdatabackend' do
  default_logger true
  subscribes :restart, 'template[/srv/afdatabackend/shared/config/database.yml]'
  subscribes :restart, 'template[/srv/afdatabackend/shared/config/secrets.yml]'
  subscribes :restart, 'file[/srv/afdatabackend/shared/.env]'
  only_if { File.exist? '/srv/afdatabackend/current' }
end
