include_attribute 'jenkins'

default['jenkins']['server']['home'] = "/srv/jenkins"
default['jenkins']['server']['host'] = '127.0.0.1'

default['jenkins']['http_proxy']['host_name'] = "jenkins.#{domain}"
default['jenkins']['http_proxy']['variant'] = 'apache2'
