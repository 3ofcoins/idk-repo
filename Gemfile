source "https://rubygems.org/"

gem "chef", "~> 11.4.0"
gem "knife-dwim"
gem "thor"
gem "foodcritic"
gem "strainer"
git "git://github.com/3ofcoins/vendorificator.git", :ref => '4b7a6eaac56ab69f70f897591de6f6748c1ba4bc' do
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
