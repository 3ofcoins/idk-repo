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

cookbook_file '/srv/afdatabackend/shared/config/htpasswd' do
  owner 'root'
  group 'www-data'
  mode 0640
end

# _rvm = ". /usr/local/rvm/environments/ruby-#{node['af']['databackend']['ruby']}"

# deploy_branch '/srv/afdatabackend' do
#   repo 'git@github.com:AnalyticsFire/afdatabackend.git'
#   branch 'master'
#   shallow_clone true
#   action ENV['FORCE_DEPLOY'] ? :force_deploy : :deploy
#   symlinks({})
#   symlink_before_migrate 'database.yml' => 'config/database.yml'
#   environment 'RAILS_ENV' => 'production'
#   migration_command "#{_rvm} ; ./bin/rake assets:precompile RAILS_ENV=production ; ./bin/rake db:migrate RAILS_ENV=production"
#   migrate true
#   before_migrate do
#     execute "set -e -x ; cd #{release_path} ; #{_rvm} ; bundle --deployment --binstubs --quiet --path /srv/afdatabackend/bundle --without development test doc"
#   end
# end

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

nginx_site "afdatabackend"

runit_service 'afdatabackend' do
  default_logger true
  subscribes :restart, 'template[/srv/afdatabackend/shared/config/database.yml]'
  only_if { File.exist? '/srv/afdatabackend/current' }
end
