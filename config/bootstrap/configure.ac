dnl -*- autoconf -*-
FB_INIT

AC_ARG_VAR([DRY_RUN], [Don't actually run anything])

FB_NEED_ROOT
FB_RUN( [initialization],
  [ set -e ; export DEBIAN_FRONTEND=noninteractive ; apt-get update --yes ])

dnl Install omnibus chef client
FB_TRY_PROG( [chef-solo], 
  [ FB_TRY_PROG([curl], [FB_INSTALL([curl])])
    FB_TRY_PROG([bash], [FB_INSTALL([bash])])
    FB_RUN( [omnibus-chef.install],
            [curl -L https://www.opscode.com/chef/install.sh | bash])])

dnl Install chef server
FB_ARG_FQDN
# FB_FILES([solo.rb.in], [dna.json.in])
FB_CONFIG_FILE([solo.rb])
FB_CONFIG_FILE([dna.json])
FB_RUN([chef-solo], [chef-solo -c solo.rb -j dna.json])

dnl Run chef-client on itself
FB_RUN([chef-client], [chef-client])

AC_OUTPUT
