# Sanitize directory structure
# ============================

directory "/opt"

directory "/srv"

directory Chef::Config[:file_cache_path] do
  recursive true
end

# Don't clutter motd.
%w(10-help-text 51_update-motd).each do |fn|
  file "/etc/update-motd.d/#{fn}" do
    action :delete
  end
end
