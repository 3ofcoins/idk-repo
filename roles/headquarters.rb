name "headquarters"
description "Heart of the operation"

run_list 'role[__base]',
         'recipe[ssl-key-vault]',
         'recipe[chef-server-webapp]',
         'recipe[apache2_odin_auth::server]',
         'recipe[jenkins-app::master]'

certificates_path = Pathname.new(__FILE__).dirname.dirname.
  join('config/certificates')

default_attributes(
  :apache2 => {
    :odin_auth => {
      :server_branch => 'develop',
      :server_config => {
        :google_apps_domain => '3ofcoins.net',
        :company => 'Three of Coins',
        :company_url => 'http://3ofcoins.net/',
        'template-variables' => {
          :links => [
            'https://jenkins.i.3ofcoins.net/',
            'https://www.hipchat.com/google/login?from=google&domain=3ofcoins.net'
          ]}},
      :server_domain => 'i.3ofcoins.net',
      :server_ssl_certificate_path => '/etc/ssl/certs/star.i.3ofcoins.net.crt',
      # :server_ssl_certificate_chain_path => '/etc/ssl/certs/codility.net.chain.pem',
      :server_ssl_key_path => '/etc/ssl/private/star.i.3ofcoins.net.key'
    }},
  :'chef-server' => {
    :api_fqdn => 'chef.i.3ofcoins.net',
    :configuration => {
      :chef_server_webui => {:enable => false },
      :notification_email => 'maciej@3ofcoins.net'},
    :webapp => {
      :ssl_key_path => '/etc/ssl/private/star.i.3ofcoins.net.key',
      :ssl_certificate_path => '/etc/ssl/certs/star.i.3ofcoins.net.crt' # ,
      # :ssl_certificate_chain_path => '/etc/ssl/certs/star.i.3ofcoins.net.chain.pem'
    }},
  :jenkins => {
    :git => {
      'user.email' => 'tachikoma@3ofcoins.net',
      'user.name' => 'Tachikoma AI (Jenkins)'
    },
    :http_proxy => {
      :ssl => {
        :enabled => true,
        :key_path => '/etc/ssl/private/star.i.3ofcoins.net.key',
        :cert_path => '/etc/ssl/certs/star.i.3ofcoins.net.crt' # ,
        # :chain_path => '/etc/ssl/certs/star.i.3ofcoins.net.chain.pem'
      }}},
  :sanitize => { :ports => { :http => true, :https => true }},
  :ssl_certificates => {
    'star.i.3ofcoins.net' => {
      'crt' => certificates_path.join('star.i.3ofcoins.net.crt').read
    }}
)
