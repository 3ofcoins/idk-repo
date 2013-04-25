dnl -*- autoconf -*-
FB_INIT

FB_ARG_VAR([NODE_NAME],       [Chef node name])
FB_ARG_VAR([CHEF_SERVER_URL], [Chef server URL]) dnl default depends on --with-chef-server
FB_ARG_VAR([RUN_LIST],        [Node's run list])
FB_ARG_VAR([FQDN],            [Desired FQDN of the server @<:@1@:>@], [`hostname -f`])
FB_ARG_VAR([FILE_CACHE_PATH], [Full pathname for files downloaded by the setup @<:@1@:>@], [`pwd`/files])
FB_ARG_VAR([VALIDATION_KEY],  [Path to validation key])

dnl Install omnibus chef client
FB_TRY_PROG( [chef-solo], 
  [ FB_TRY_PROG([curl], [FB_INSTALL([curl])])
    FB_TRY_PROG([bash], [FB_INSTALL([bash])])
    FB_RUN( [curl -L https://www.opscode.com/chef/install.sh | bash] )])

dnl Install chef server when asked to
AC_ARG_WITH([chef-server],
  [AS_HELP_STRING([--with-chef-server[[=VERSION]]], [Bootstrap a Chef server])],
  [], [with_chef_server=no])
AS_IF([test "x$with_chef_server" = xno],
  [ dnl Set default CHEF_SERVER_URL only when we're not the server ourselves
    AS_IF( [test "x$CHEF_SERVER_URL" = 'x'], [CHEF_SERVER_URL='http://127.0.0.1:4000/'])],
  [ FB_CONFIG_FILE([solo.rb])
    FB_CONFIG_FILE([dna.json])
    FB_RUN([chef-solo -c solo.rb -j dna.json])
    FB_RUN([test -f /etc/chef/validation.pem || cp /etc/chef-server/chef-validator.pem /etc/chef/validation.pem])
    AS_IF( [test "x$CHEF_SERVER_URL" != 'x'],
           [AC_MSG_WARN([Keeping provided CHEF_SERVER_URL="$CHEF_SERVER_URL"])],
           [CHEF_SERVER_URL="https://$FQDN/"])])

dnl Run chef-client
AS_IF( [test "x$CHEF_SERVER_URL" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -S $CHEF_SERVER_URL"])] )
AS_IF( [test "x$NAME" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -N $NAME"])] )
AS_IF( [test "x$VALIDATION_KEY" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -K $VALIDATION_KEY"])] )
AS_IF( [test "x$RUN_LIST" != x],
       [ FB_RUN([/opt/chef/embedded/bin/ruby -rjson -e 'puts JSON.dump(run_list: ARGV.first.split)' -- "$RUN_LIST" > first-boot.json])
         AS_VAR_APPEND([_chef_client_args], [" -j ./first-boot.json"]) ])
AC_SUBST([_chef_client_args], [$_chef_client_args])
dnl FIXME: AC_PROG_MKDIR_P? Then I'd to have install-sh bundled, though...
FB_RUN( [test -d /etc/chef || mkdir /etc/chef] )
FB_RUN( [exec chef-client$_chef_client_args] )

AC_OUTPUT
