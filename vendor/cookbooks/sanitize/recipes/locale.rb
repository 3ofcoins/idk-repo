# Normalize local settings
# ========================

require 'set'
require 'chef/mixin/shell_out'

class << self
  include Chef::Mixin::ShellOut
end

def normalize_locale(loc)
  loc.sub(/\.utf-?8$/i, '.UTF-8')
end

locales = Set[*Array(node['sanitize']['locale']['available'])]
locales << node['sanitize']['locale']['default']
locales.map! { |loc| normalize_locale(loc) }

known_locales = Set[*shell_out!('locale -a').stdout.lines.map(&:strip)]
known_locales.map!  { |loc| normalize_locale(loc) }

locales.each do |loc|
  execute "locale-gen #{loc}" do
    not_if { known_locales.include?(loc) }
  end
end

default_locale = normalize_locale(node['sanitize']['locale']['default'])

file '/etc/default/locale' do
  content "LANG=#{default_locale}\n"
  owner 'root'
  group 'root'
  mode '0644'
  not_if { node['platform_family'] == 'mac_os_x' }
end

execute "configure time zone" do
  action :nothing
  command "dpkg-reconfigure -fnoninteractive tzdata"
  only_if { node['platform_family'] == 'debian' }
end

file '/etc/timezone' do
  content "Etc/UTC\n"
  notifies :run, "execute[configure time zone]", :immediately
  only_if { node['platform_family'] == 'debian' }
end
