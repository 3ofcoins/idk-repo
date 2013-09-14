name             "chef-server-webapp"
maintainer       "Maciej Pasternacki"
maintainer_email "maciej@3ofcoins.net"
license          'MIT'
description      "Configures Omnibus Chef server as an Apache webapp"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

depends 'apache2'
depends 'chef-server', '>= 2.0.0'
