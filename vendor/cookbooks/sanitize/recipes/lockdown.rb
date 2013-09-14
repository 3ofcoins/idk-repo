# Delete or disable old system users
# ==================================

#
# Delete default 'ubuntu' user if it exists; it's provided by the EC2 image.

# HACK: Forget about ubuntu user we're about to force delete
Dir.chdir('/root') if Dir.getwd == '/home/ubuntu'
ENV['HOME'] = '/root' if ENV['HOME'] == '/home/ubuntu'
Gem.user_home = '/root' if Gem.user_home == '/home/ubuntu'

user 'ubuntu' do
  action :remove
  supports :manage_home => true
  ignore_failure true
end

#
# Lock out root account - sudo-only. Make sure this runs AFTER your
# users accounts and sudoers file are set up.
user "root" do
  action :lock
end
