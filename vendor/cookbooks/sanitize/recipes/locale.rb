# Normalize local settings
# ========================

execute 'locale-gen en_US.UTF-8' do
  not_if do
    cmd = Mixlib::ShellOut.new('locale', '-a')
    cmd.run_command
    cmd.error!
    cmd.stdout.lines.map(&:strip).any? { |ln| ln =~ /^en_US.(?i:utf-?8)$/ }
  end
end

file '/etc/default/locale' do
  content 'LANG=en_US.UTF-8'
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
