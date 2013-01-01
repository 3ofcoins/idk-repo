name 'chef-server-bootstrap'
description 'Chef server - bootstrap role for chef-solo'

run_list( 'recipe[ruby]',
          'recipe[ruby::symlinks]',
          'recipe[build-essential]',
          'recipe[chef-server::rubygems-install]' )

default_attributes(
  'languages' => { 'ruby' => {'default_version' => '1.9.1' } }, # which is actually 1.9.3
  'chef_server' => {
    'server_url' => 'http://localhost:4000',
    'init_style' => 'runit'
  })
