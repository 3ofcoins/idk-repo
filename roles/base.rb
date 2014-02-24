name "base"
description "Base role applied to all nodes."

run_list *[
  ( 'recipe[chef-solo-search]' if Chef::Config[:solo] )
  'role[attributes]',
  'recipe[apt]',
  'recipe[ohai]',
  'recipe[omnibus_updater]',
  ( 'recipe[chef-client::config]' unless Chef::Config[:solo] ),
  'recipe[sudo]',
  'recipe[users::sysadmins]',
  'recipe[sanitize]',
  'recipe[hostname]' ].compact

default_attributes(
  :authorization => {
    :sudo => {
      :agent_forwarding => true,
      :groups => ['sysadmin'],
      :include_sudoers_d => true,
      :passwordless => true}},
  :domain => $realm.domain,
  :omnibus_updater => {
    :version => '11.10.4',
    :remove_chef_system_gem => true,
    :cache_dir => '/var/cache/chef' },
  :sanitize => {
    :iptables => false,
    :keep_access => ::Dir[$realm.path('data_bags/users/*.json')].empty?
  },
  :set_fqdn => "*.#{$realm.domain}")

instance_load_subdir
