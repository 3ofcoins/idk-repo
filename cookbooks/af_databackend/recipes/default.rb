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

group 'afdb'

user 'afdb' do
  group 'afdb'
  home '/srv/afdatabackend'
  shell '/bin/bash'
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

directory '/srv/afdatabackend/shared'
template '/srv/afdatabackend/shared/database.yml' do
  owner 'root'
  group 'www-data'
  mode '0640'
end

_rvm = ". /usr/local/rvm/environments/ruby-#{node['af']['databackend']['ruby']}"

deploy_branch '/srv/afdatabackend' do
  repo 'git@github.com:AnalyticsFire/afdatabackend.git'
  branch 'master'
  shallow_clone true
  action ENV['FORCE_DEPLOY'] ? :force_deploy : :deploy
  symlinks({})
  symlink_before_migrate 'database.yml' => 'config/database.yml'
  environment 'RAILS_ENV' => 'production'
  migration_command "#{_rvm} ; ./bin/rake db:migrate RAILS_ENV=production"
  migrate true
  before_migrate do
    execute "set -e -x ; cd #{release_path} ; #{_rvm} ; bundle --deployment --binstubs --quiet --path /srv/afdatabackend/bundle --without development test doc ; ./bin/rake assets:precompile"
  end
end

cookbook_file '/srv/afdatabackend/htpasswd' do
  owner 'root'
  group 'www-data'
  mode 0640
end

template "#{node['nginx']['dir']}/sites-available/afdatabackend" do
  source 'nginx.conf.erb'
  notifies :reload, 'service[nginx]'
end
nginx_site "afdatabackend"

runit_service 'afdatabackend' do
  sv_dir '/srv'
  default_logger true
  subscribes :restart, 'deploy_branch[/srv/afdatabackend]'
end
