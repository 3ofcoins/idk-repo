# Apt configuration and default repos and packages
# ================================================

include_recipe 'apt'

# Why not?
link "/usr/local/bin/can-has" do
  to "/usr/bin/apt-get"
end

# Custom repos
node['sanitize']['apt_repositories'].each do |name, repo|
  distribution_name = if repo['distribution'] == 'lsb_codename'
                        node['lsb']['codename']
                      else
                        repo['distribution']
                      end

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

