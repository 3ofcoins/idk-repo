# -*- mode: ruby; coding: utf-8 -*-

libdir = File.realpath(File.join(File.dirname(__FILE__), '../lib'))
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'idk/config'
require 'chef'
require 'chef/knife'

$realm.config_files('rb').each do |f|
  load f
end

tasks = ['vendor/cookbooks/**/tasks/*.rb', 'vendor/cookbooks/**/tasks/*.rake']

tasks.each do |glob|
  Dir.glob(glob).each do |file|
    File.open(File.join(Chef::Config.find_chef_repo_path(libdir), file)) do |f|
      load f
    end
  end
end
