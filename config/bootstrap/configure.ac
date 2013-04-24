dnl -*- autoconf -*-
FB_INIT

FB_ARG_VAR( [DRY_RUN], [Don't actually run anything] )
FB_ARG_VAR( [FOUNDATION_ROOT], [Root directory of the Foundation repository],
            [$ac_top_srcdir/../..] )
FB_ARG_VAR( [FQDN], [Desired fully qualified domain name of the server],
            [`hostname -f`] )
FB_ARG_VAR( [NAME], [Chef node name] )
FB_ARG_VAR( [CHEF_SERVER_URL], [Chef server URL] )

FB_NEED_ROOT
FB_RUN( [initialization],
  [ set -e ; export DEBIAN_FRONTEND=noninteractive ; apt-get update --yes ])

dnl Install omnibus chef client
FB_TRY_PROG( [chef-solo], 
  [ FB_TRY_PROG([curl], [FB_INSTALL([curl])])
    FB_TRY_PROG([bash], [FB_INSTALL([bash])])
    FB_RUN( [omnibus-chef.install],
            [curl -L https://www.opscode.com/chef/install.sh | bash])])

dnl Install chef server when asked
AC_ARG_WITH([chef-server],
  [AS_HELP_STRING([--with-chef-server[[=VERSION]]], [Bootstrap a Chef server])])
AS_IF([test "x$with_chef_server" != xno],
  [ FB_CONFIG_FILE([solo.rb])
    FB_CONFIG_FILE([dna.json])
    FB_RUN([chef-solo], [chef-solo -c solo.rb -j dna.json])
    test -f /etc/chef/validation.pem || cp /etc/chef-server/chef-validator.pem /etc/chef/validation.pem
    AS_IF( [test "x$CHEF_SERVER_URL" != 'x'],
           [AC_MSG_WARN([Keeping provided CHEF_SERVER_URL="$CHEF_SERVER_URL"])],
           [CHEF_SERVER_URL="https://$FQDN/"]) ])

dnl Run chef-client
AS_IF( [test "x$CHEF_SERVER_URL" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -S $CHEF_SERVER_URL"])] )
AS_IF( [test "x$NAME" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -N $NAME"])] )
FB_RUN([chef-client], [chef-client$_chef_client_args], [_chef_client_args="$_chef_client_args"])

AC_OUTPUT
