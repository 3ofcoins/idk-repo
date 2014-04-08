# -*- mode: ruby; coding: utf-8 -*-

libdir = File.realpath(File.join(File.dirname(__FILE__), 'lib'))
$:.unshift(libdir) unless $:.include?(libdir)

require 'idk/config'

$realm.config_files('rake').each { |f| load f }

Dir['lib/tasks/*.rake', 'vendor/cookbooks/*/files/tasks/*.rake'].sort.each do |f|
  load f
end
