# Git Annex
# =========

case node['platform']
when 'mac_os_x'
  include_recipe 'dmg'

  case node['platform_version']
  when /^10\.6\./
    dmg_url = "https://s3.amazonaws.com/downloads.3ofcoins.net/git-annex/OSX-10.6-Snow_Leopard/git-annex.dmg.bz2"
  when /^10\.7\./
    dmg_url = "http://downloads.kitenet.net/git-annex/OSX/current/10.7.5_Lion/git-annex.dmg"
  when /^10\.8\./
    dmg_url = "http://downloads.kitenet.net/git-annex/OSX/current/10.8.2_Mountain_Lion/git-annex.dmg.bz2"
  when /^10\.9\./
    dmg_url = "http://downloads.kitenet.net/git-annex/OSX/current/10.9_Mavericks/git-annex.dmg"
  else
    raise "OSX #{node['platform_version']} not supported"
  end

  dmg_path = "#{Chef::Config[:file_cache_path]}/git-annex.dmg"

  if dmg_url =~ /\.bz2$/
    remote_file "#{dmg_path}.bz2" do
      source dmg_url
    end

    execute "bunzip2 -c #{dmg_path}.bz2 > #{dmg_path}" do
      creates dmg_path
    end

    dmg_package 'git-annex' do
      action :install
    end
  else
    dmg_package 'git-annex' do
      source dmg_url
      action :install
    end
  end

  directory "/usr/local/bin"

  %w[git-annex git-annex-shell git-annex-webapp runshell bundle].each do |bin|
    link "/usr/local/bin/#{bin}" do
      to "/Applications/git-annex.app/Contents/MacOS/#{bin}"
    end
  end
when 'ubuntu'
  include_recipe 'apt'
  apt_repository "git-annex" do
    uri 'http://ppa.launchpad.net/fmarier/git-annex/ubuntu'
    distribution node['lsb']['codename']
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "90F7E9EB"
    only_if { node['platform'] == 'ubuntu' && node['lsb']['codename'] == 'precise' }
  end
  package 'git-annex'
else
  if node['os'] == 'linux'
    ga_arch = case node['kernel']['machine']
              when /^i.86$/ then 'i386'
              when 'amd64', 'x86_64' then 'amd64'
              when 'armel' then 'armel'
              else raise "Unsupported machine #{node['kernel']['machine']}"
              end
    ga_path = "#{Chef::Config[:file_cache_path]}/git-annex.tar.gz"
    remote_file ga_path do
      source "https://downloads.kitenet.net/git-annex/linux/current/git-annex-standalone-#{ga_arch}.tar.gz"
    end

    execute "tar -C /opt -xzf #{ga_path}" do
      creates "/opt/git-annex.linux/git-annex"
    end

    link "/usr/local/bin/git-annex" do
      to "/opt/git-annex.linux/git-annex"
    end
  else
    raise "Only Linux and OSX is supported"
  end
end
