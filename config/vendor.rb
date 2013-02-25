require 'vendorificator/vendor/chef_cookbook'

archive :virtualenv,
        :url => 'http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.8.4.tar.gz',
        :version => '1.8.4-1' do
  FileUtils::rm_rf Dir.entries('.')-%w|.. . AUTHORS.txt LICENSE.txt README.rst virtualenv.py|
end

chef_cookbook 'build-essential'
chef_cookbook 'ruby'
chef_cookbook 'omnibus_updater'

class <<  git 'git://github.com/opscode-cookbooks/chef-server.git',
              :branch => 'master',
              :category => :cookbooks,
              :version => '2.0.0pre20130225'
  include Vendorificator::Hooks::ChefCookbookDependencies
end
