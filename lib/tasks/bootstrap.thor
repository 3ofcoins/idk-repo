# -*- mode: ruby; coding: utf-8 -*-
class Bootstrap < Thor::Group
  include Thor::Actions

  desc "Bootstrap an infrastructure repo"

  def rubygems
    run 'gem install --file config/gems.rb' or fail "Can't install rubygems"
    Gem.clear_paths
  end

  def configure!
    require 'idk/config'
  end

  def git_config
    until correct?('git config user.email', $realm.git['user.email']) { |val|
        val && val =~ $realm.email_regexp }
      $realm.git['user.email'] =
        ask("What is your \"@#{$realm.email_domain}\" email?")
    end

    until correct?('git config user.name', $realm.git['user.name']) {|_|_}
      $realm.git['user.name'] = ask('What is your full name?')
    end
  end

  def ssh_config
    require 'net/ssh/config'
    cfg = Net::SSH::Config.for($realm.headquarters)
    correct?("SSH agent forwarding", cfg[:forward_agent] && OK)
    correct?("SSH username", cfg[:user]) { |u| u == $realm.username }

    agent_out=`ssh-add -l 2>&1`.strip
    correct?("SSH agent", $?.success? ? OK : agent_out)

    { 'whoami' => $realm.username, 'sudo whoami' => 'root' }.each do |cmd, eout|
      out, es = hq(cmd)
      out << " (#{es})" unless es.zero?
      correct?( "[#{$realm.headquarters}] #{cmd}", out ) { |v| v == eout }
    end
  end

  def knife_config
    create_link '.chef/knife.rb', '../lib/config/knife.rb',
                force: true, verbose: false
    chmod '.chef', 0700, verbose: false

    client_pem = $realm.path('.chef/client.pem')
    if File.exist?(client_pem)
      correct?(client_pem, OK)
    else
      correct?(client_pem, 'no file')
      if shell.yes?("Create or reregister chef API user now? (yes/no)")
        tmpf, rv = hq('mktemp')
        out, rv = hq_knife("user show #{$realm.chef_username}")
        if rv.zero?
          cmd = "[#{$realm.headquarters}] knife user reregister #{$realm.chef_username}"
          say_status "\u2026", cmd, :yellow
          out, rv = hq_knife "user reregister --yes --disable-editing #{$realm.chef_username} --file #{tmpf}"
        else
          require 'securerandom'
          cmd = "[#{$realm.headquarters}] knife user create --admin #{$realm.chef_username}"
          say_status "\u2026", cmd, :yellow
          out, rv = hq_knife "user create --yes --disable-editing --password #{SecureRandom.hex(128)} --admin --file #{tmpf} #{$realm.chef_username}"
        end
        if rv.zero?
          say_status "\u2713", cmd, :green
          say out
          key, rv = hq("cat #{tmpf}")
          create_file(client_pem, key)
        else
          say_status "\u2717", cmd, :red
          say out
        end
        hq 'rm -f #{tmpf}'
      else
        say_status 'I give up.',
                   "Bring me your .chef/client.pem file yourself!",
                   :red
        abort
      end
    end

    output = `knife status 2>&1`
    correct?("knife status", $?.success? ? OK : output)
  end

  def git_annex
    $realm.git.annex 'init' unless File.directory?($realm.path('.git/annex'))
    $realm.git['annex.chef-vault-hook'] = 'knife annex'
    $realm.git['remote.origin.annex-ignore'] = 'true'
    $realm.git.annex :enableremote, 'chef-server'
    $realm.git.annex :get
  end

  private

  OK = Object.new
  class << OK
    def inspect
      'OK'
    end
  end

  def correct?(description, value)
    if block_given? ? yield(value) : value == OK
      shell.say_status "\u2713", "#{description}: #{value.inspect}", :green
      true
    else
      shell.say_status "\u2717", "#{description}: #{value.inspect}", :red
      false
    end
  end

  def hq(cmd)
    @hq ||= begin
              require 'net/ssh'
              Net::SSH.start($realm.headquarters, $realm.username)
            end
    rv = @hq.exec!("( #{cmd} ) ; echo $?").strip
    rv =~ /\d+\s*\z/
    [ ($` && $`.strip), $&.to_i ]
  end

  def hq_knife(knife_cmd)
    hq("sudo knife #{knife_cmd} --config /etc/chef/client.rb --key /etc/chef-server/admin.pem --user admin")
  end
end
