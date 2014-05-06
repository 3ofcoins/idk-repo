include_recipe 'docker'
include_recipe 'nginx-proxy'

docker_image '3ofcoins/chef-server:11.0.11'

directory '/srv/chef-server' do
  recursive true
end

docker_container 'chef-server' do
  container_name 'chef-server'
  hostname 'chef-server'
  image '3ofcoins/chef-server:11.0.11'
  port '127.0.0.1:4000:443'
  env %w[PUBLIC_URL=https://chef-api.analyticsfire.com/ DISABLE_WEBUI=1]
  volume '/srv/chef-server:/var/opt/chef-server'
  detach true
  subscribes :redeploy, 'docker_image[3ofcoins/chef-server:11.0.11]'
end

nginx_proxy 'chef-api.analyticsfire.com' do
  ssl_key 'star.analyticsfire.com'
  url 'https://127.0.0.1:4000'
  custom_config 'client_max_body_size 32M;'
end

directory '/srv/backup/chef-server'

cookbook_file '/srv/backup/chef-server/backup.sh' do
  source 'chef-server-backup.sh'
  mode 0755
end

cron 'tarsnap::chef-server' do
  command 'cd /srv/backup/chef-server && ./backup.sh'
  minute '15'
  hour '8'
  only_if { node.chef_environment == 'production' }
end
