#!/bin/sh
set -e -x

fqdn=$1
ipaddr=$2

export DEBIAN_FRONTEND=noninteractive

### Basic update/upgrade
apt-get update
apt-get upgrade -y

## Force UTC from the very beginning
echo Etc/UTC > /etc/timezone
dpkg-reconfigure tzdata

## Base packages
apt-get install -y curl realpath

## Configuration
foundation_root=$(realpath $(dirname $0)/../..)

if [ -z "$fqdn" ] ; then
    fqdn='chef.localdomain'
fi

if [ -z "$ipaddr" ] ; then
    ipaddr=`ifconfig eth0 | perl -ne '/inet addr:([\d\.]+)/g and print $1'`
fi

hostname=`echo $fqdn | cut -d. -f1`
sed -e "/$ipaddr/d" -e "\$a$ipaddr $fqdn $hostname" -i~ /etc/hosts
hostname $hostname

## Install Chef client for chef-solo
curl -L https://www.opscode.com/chef/install.sh | bash

cat >/tmp/chef-solo.rb <<EOF
file_cache_path "/tmp/chef-solo"
cookbook_path "$foundation_root/vendor/cookbooks"
role_path "$foundation_root/roles"
EOF

chef-solo -c /tmp/chef-solo.rb -o 'role[chef-server-bootstrap]'

# Wait until chef-server initializes itself
until [ -f /etc/chef/validation.pem ] ; do sleep 1 ; done

# Run chef client, as a test
chef-client -N $hostname
