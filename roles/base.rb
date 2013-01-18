name "base"
description "Base role applied to all nodes."

run_list( 'recipe[apt]',
          'recipe[omnibus_updater]' )

default_attributes(
  :omnibus_updater => {
    :version => '10.18.0',
    :remove_chef_system_gem => true, # This should be overriden to
                                     # false in the chef server
    :cache_dir => '/var/cache/chef' })
