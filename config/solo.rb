_basedir = File.expand_path(File.dirname(File.dirname(__FILE__)))

_libdir = File.join(_basedir, 'lib')
$:.unshift(_libdir) unless $:.include?(_libdir)
require 'idk/config'

file_cache_path File.join(_basedir, 'tmp/cache')
cookbook_path [ "#{_basedir}/cookbooks", "#{_basedir}/vendor/cookbooks" ]
verbose_logging false

FileUtils.mkdir_p file_cache_path
