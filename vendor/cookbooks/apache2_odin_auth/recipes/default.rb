node.default['apache2']['odin_auth']['server_domain'] ||= node['domain']

include_recipe "build-essential"
include_recipe "apache2"
include_recipe "perl"

package "libapache2-mod-perl2"
package "libcrypt-ssleay-perl"  # for https in cpanm
package "libexpat1-dev"         # for XML::Parser

cpan_module "Apache2::Authen::OdinAuth"

if node.run_list.expand(node.chef_environment).recipes.include?('apache2_odin_auth::server')
  server_node = node
else
  if Chef::Config[:solo]
    raise "This cookbook needs search. It won't work with chef-solo."
  else
    server_node = search(:node, "apache2_odin_auth_server_domain:#{node['apache2']['odin_auth']['server_domain']} AND apache2_odin_auth_secret:[* TO *]").first
  end
end

proto = ( !!server_node['apache2']['odin_auth']['server_ssl_key_path'] ? 'https' : 'http')
client_config = {
  'permissions' => node['apache2']['odin_auth']['permissions'] ? JSON::load(JSON::dump(node['apache2']['odin_auth']['permissions'])) : [ { 'url' => '', 'who' => 'authed' } ],
  'secret' => server_node['apache2']['odin_auth']['secret'],
  'cookie' => server_node['apache2']['odin_auth']['cookie_name'],
  'need_auth_url' => "#{proto}://#{server_node['apache2']['odin_auth']['server_domain']}/",
  'invalid_cookie_url' => "#{proto}://#{server_node['apache2']['odin_auth']['server_domain']}/?why=invalid-cookie",
  'not_on_list_url' => "#{proto}://#{server_node['apache2']['odin_auth']['server_domain']}/?why=not-on-list",
  'reload_timeout' => 600 }

file '/etc/apache2/odin_auth.yml' do
  content client_config.to_yaml
  group 'www-data'
  mode '0640'
end

file "/etc/apache2/conf.d/odin_auth.conf" do
  content "PerlSetVar odinauth_config /etc/apache2/odin_auth.yml\n"
  mode '0644'
  notifies :restart, 'service[apache2]'
end
