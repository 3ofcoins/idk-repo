name             'af_databackend'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures af_databackend'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'database'
depends 'git'
depends 'nginx'
depends 'openssl'
depends 'runit'
depends 'rvm'
