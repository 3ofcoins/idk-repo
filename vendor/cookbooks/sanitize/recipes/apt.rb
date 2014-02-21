# Apt configuration and default repos and packages
# ================================================

require 'open-uri'

include_recipe 'apt'

# Why not?
link "/usr/local/bin/can-has" do
  to "/usr/bin/apt-get"
end

# Custom repos
node['sanitize']['apt_repositories'].each do |name, repo|
  repo = { 'ppa' => Regexp.last_match.post_match } if String === repo && repo =~ /^ppa:/
  repo = repo.to_hash

  if repo['ppa']
    user, archive = repo['ppa'].split('/')

    repo['uri'] ||= "http://ppa.launchpad.net/#{repo['ppa']}/ubuntu"
    repo['distribution'] ||= node['lsb']['codename']
    repo['components'] ||= [ 'main' ]
    repo['keyserver'] ||= 'keyserver.ubuntu.com'
    repo['key'] ||= JSON[
      open("https://api.launchpad.net/1.0/~#{user}/+archive/#{archive}").read
    ]['signing_key_fingerprint']
  end

  repo['distribution'] = node['lsb']['codename'] if repo['distribution'] == 'lsb_codename'

  apt_repository name do
    action repo['action'] if repo['action']
    uri repo['uri'] if repo['uri']
    distribution distribution_name if distribution_name
    components repo['components'] if repo['components']
    deb_src repo['deb_src'] if repo['deb_src']
    keyserver repo['keyserver'] if repo['keyserver']
    key repo['key'] if repo['key']
    cookbook repo['cookbook'] if repo['cookbook']
  end
end

# Custom packages
node['sanitize']['install_packages'].each do |pkg_name|
  package pkg_name
end

