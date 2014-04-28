run_list << 'recipe[openssh]'

default_attributes[:openssh] = {
  client: {
    g_s_s_a_p_i_authentication: 'yes',
    g_s_s_a_p_i_delegate_credentials: 'no',
    hash_known_hosts: 'no',
    send_env: 'LANG LC_*'
  },
  server: {
    accept_env: 'LANG LC_*',
    challenge_response_authentication: 'no',
    client_alive_count_max: 5,
    client_alive_interval: 60,
    gateway_ports: 'clientspecified',
    host_based_authentication: 'no',
    host_key: [
      '/etc/ssh/ssh_host_rsa_key',
      '/etc/ssh/ssh_host_dsa_key',
      '/etc/ssh/ssh_host_ecdsa_key'],
    ignore_rhosts: 'yes',
    key_regeneration_interval: 3600,
    log_level: 'INFO',
    login_grace_time: 120,
    password_authentication: 'no',
    permit_empty_passwords: 'no',
    permit_root_login: 'no',
    port: 22,
    print_last_log: 'yes',
    print_motd: 'no',
    protocol: 2,
    pubkey_authentication: 'yes',
    r_s_a_authentication: 'yes',
    rhosts_r_s_a_authentication: 'no',
    server_key_bits: 768,
    strict_modes: 'yes',
    subsystem: 'sftp /usr/lib/openssh/sftp-server',
    syslog_facility: 'AUTH',
    t_c_p_keep_alive: 'yes',
    use_p_a_m: 'no',
    use_privilege_separation: 'yes',
    x11_display_offset: 10,
    x11_forwarding: 'yes'
  }
}
