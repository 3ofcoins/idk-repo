source :rubygems

gem "chef"
gem "knife-dwim"
gem "thor"
gem "foodcritic"
gem "vagrant"
gem "strainer"
git "git://github.com/3ofcoins/vendorificator.git", :ref => '0cf94bcfee46f8a5415a2a771fc2ade0da08a5f9' do
  gem "vendorificator"
end

# Needed by code in lib/ - probably better in a gemspec
gem "mixlib-config"
gem "net-ssh"

group :development do
  gem "pry"
  gem "awesome_print"
end

# Local library path
_lib_dir = File.join(File.dirname(__FILE__), 'lib')
$:.unshift(_lib_dir) unless $:.include?(_lib_dir)
