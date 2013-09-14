# Apache2 Odin Auth Attributes
# ============================

default['apache2']['odin_auth']['server_domain'] = nil
default['apache2']['odin_auth']['server_branch'] = 'master'
default['apache2']['odin_auth']['server_config']['log'] = 'warning'
default['apache2']['odin_auth']['server_config']['odin-auth']['roles'] = 'admin'
default['apache2']['odin_auth']['server_config']['odin-auth']['expires'] = '5 days'
default['apache2']['odin_auth']['server_config']['route_cache'] = 1
default['apache2']['odin_auth']['server_config']['show_errors'] = 0
default['apache2']['odin_auth']['server_config']['warnings'] = 0
default['apache2']['odin_auth']['server_ssl_certificate_path'] = nil
default['apache2']['odin_auth']['server_ssl_certificate_chain_path'] = nil
default['apache2']['odin_auth']['server_ssl_key_path'] = nil
default['apache2']['odin_auth']['cookie_name'] = 'oa'
