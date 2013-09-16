name             'jenkins-app'
maintainer       'Maciej Pasternacki'
maintainer_email 'maciej@3ofcoins.net'
license          'MIT'
description      'Configures Jenkins'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'build-essential'
depends 'docker'
depends 'git'
depends 'jenkins', '>= 1.0.0'
depends 'perl'
depends 'postfix'
