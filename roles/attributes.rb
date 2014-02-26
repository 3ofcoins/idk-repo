name 'attributes'
description 'Default attributes to be also used on unmanaged machines configured by chef-solo'

default_attributes(
  :java => {
    :install_flavor => 'oracle',
    :jdk_version => '7',
    :oracle => { :accept_oracle_download_terms => true }
  },
  nginx: {
    default_site_enabled: false,
    repo_source: 'nginx',
    upstream_repository: "http://nginx.org/packages/mainline/ubuntu"
  },
  :nodejs => {
    :install_method => 'package'
  },
  :perl => {
    :cpanm => {
      :url => 'https://raw.github.com/miyagawa/cpanminus/1.7102/cpanm',
      :checksum => '0b67f5c721259d4185bacdcbc87b835821246fe8ac7ad980d3b1a18ecdd10ff6'
    }},
  :postgresql => {
    :config => {
      :ssl => false
    },
    :enable_pgdg_apt => true,
    :version => '9.3'
  },
  :rabbitmq => {
    :version => '3.2.2'
  },
  :redisio => {
    :default_settings => {
      :loglevel => 'notice'
    }},
  :rvm => {
    :default_ruby => "system",
    # :upgrade => "stable",
  },
  :sanitize => {
    :locale => {
      :available => [ 'pl_PL.UTF-8' ]
    }}
)
