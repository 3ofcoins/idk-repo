default['sanitize']['iptables'] = true
default['sanitize']['keep_access'] = false
default['sanitize']['install_packages'] = []
default['sanitize']['packages'] = {}
default['sanitize']['apt_repositories'] = {}
default['sanitize']['ports']['ssh'] = true
default['sanitize']['chef_helpers_version'] = '>= 0.0.7'
default['sanitize']['locale']['default'] = 'en_US.UTF-8'
default['sanitize']['locale']['available'] = []

default['sanitize']['chef_gems']['chef-helpers'] = '~> 0.1'
default['sanitize']['chef_gems']['chef-sugar']['version'] = '~> 1.1'
default['sanitize']['chef_gems']['chef-sugar']['require'] = 'chef/sugar'
default['sanitize']['chef_gems']['chef-rewind']['version'] = '~> 0.0.8'
default['sanitize']['chef_gems']['chef-rewind']['require'] = 'chef/rewind'
default['sanitize']['chef_gems']['chef-vault']['version'] = '~> 2.1'
