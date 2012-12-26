source :rubygems

gem "chef"
gem "knife-dwim"
gem "thor"
gem "foodcritic"
gem "vagrant"
gem "strainer"
git "git://github.com/3ofcoins/vendorificator.git", :ref => '12ba6670e0dc3f15c8e639c911d04532a6733960' do
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
