# iptables settings
# =================

include_recipe 'iptables'

iptables_rule "ports_sanitize"
