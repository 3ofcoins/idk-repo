name "__base"
description "Base role applied to all nodes. It should be included in the base role of a concrete deployment."

run_list 'recipe[apt]',
         'recipe[omnibus_updater]',
         'recipe[chef-client::config]'

default_attributes(
  :omnibus_updater => {
    :version => '11.4.4-1',
    :remove_chef_system_gem => true,
    :cache_dir => '/var/cache/chef' })
