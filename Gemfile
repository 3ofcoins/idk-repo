source "https://rubygems.org/"

gem "nanodoc", :git => "git@github.com:3ofcoins/nanodoc.git"

# Needed by code in lib/ - probably better in a gemspec
gem "mixlib-config"
gem "net-ssh"

group :development do
  gem "pry"
  gem "pry-debugger"
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "awesome_print"
end

# Local library path
_lib_dir = File.join(File.dirname(__FILE__), 'lib')
$:.unshift(_lib_dir) unless $:.include?(_lib_dir)
