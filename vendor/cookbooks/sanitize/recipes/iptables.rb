# iptables settings
# =================

include_recipe 'iptables'

rules = node['sanitize']['ports'].to_hash.map do |port, allows|
  dst_opt = case port
            when Integer then "--dport #{port}"
            when /[,:]/  then "-m multiport --dports #{port}"
            else              "--dport #{Socket.getservbyname(port.to_s)}"
            end

  Array(allows).select { |v| v }.map do |allow|
    src_opt = case allow
              when true then ""
              else           "--src #{allow}"
              end
    "-p tcp -m tcp #{dst_opt} #{src_opt}"
  end
end
rules.flatten!
rules.sort!

iptables_rule "ports_sanitize" do
  variables :rules => rules
end
