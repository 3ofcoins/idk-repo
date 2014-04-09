name 'headquarters'

run_list 'role[base]',
         'recipe[ssl-key-vault]'

default_attributes(
  ssl_certificates: {
    'star.analyticsfire.com' => true
  })
