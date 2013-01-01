require 'vendorificator/vendor/chef_cookbook'

archive :virtualenv,
        :url => 'http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.8.4.tar.gz',
        :version => '1.8.4-1' do
  FileUtils::rm_rf Dir.entries('.')-%w|.. . AUTHORS.txt LICENSE.txt README.rst virtualenv.py|
end

chef_cookbook 'chef-server'
chef_cookbook 'ruby'
