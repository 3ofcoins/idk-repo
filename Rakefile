# -*- mode: ruby; coding: utf-8 -*-

libdir = File.realpath(File.join(File.dirname(__FILE__), 'lib'))
$:.unshift(libdir) unless $:.include?(libdir)

require 'idk/config'

Dir['lib/tasks/*.rake', 'vendor/cookbooks/*/tasks/*.rake'].sort.each do |f|
  load f
end
