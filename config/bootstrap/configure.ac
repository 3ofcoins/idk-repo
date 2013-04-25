dnl -*- autoconf -*-
FB_INIT

FB_ARG_VAR([NODE_NAME],       [Chef node name])
FB_ARG_VAR([CHEF_SERVER_URL], [Chef server URL]) dnl default depends on --with-chef-server
FB_ARG_VAR([RUN_LIST],        [Node's run list])
FB_ARG_VAR([FQDN],            [Desired FQDN of the server @<:@1@:>@], [`hostname -f`])
FB_ARG_VAR([FILE_CACHE_PATH], [Full pathname for files downloaded by the setup @<:@1@:>@], [`pwd`/files])
FB_ARG_VAR([VALIDATION_KEY],  [Path to validation key])

dnl Install omnibus chef client
FB_TRY_PROG([chef-client], [FB_INSTALL_OMNIBUS_CHEF])

dnl Install chef server when asked to
AC_ARG_WITH([chef-server],
  [AS_HELP_STRING([--with-chef-server[[=VERSION]]], [Bootstrap a Chef server])],
  [], [with_chef_server=no])
AS_IF([test "x$with_chef_server" = xno],
  [ dnl Set default CHEF_SERVER_URL only when we're not the server ourselves
    AS_IF( [test "x$CHEF_SERVER_URL" = 'x'], [CHEF_SERVER_URL='http://127.0.0.1:4000/'])],
  [ AC_CONFIG_FILES([solo.rb dna.json])
    FB_RUN([chef-solo -c solo.rb -j dna.json])
    CHEF_SERVER_URL="https://$FQDN/"
    VALIDATION_KEY="/etc/chef-server/chef-validator.pem"
])

AC_PROG_MKDIR_P

dnl Run chef-client
AS_IF( [test "x$CHEF_SERVER_URL" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -S $CHEF_SERVER_URL"])] )
AS_IF( [test "x$NAME" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -N $NAME"])] )
AS_IF( [test "x$VALIDATION_KEY" != x],
       [AS_VAR_APPEND([_chef_client_args], [" -K $VALIDATION_KEY"])] )
AC_SUBST([CHEF_CLIENT_ARGS], [$_chef_client_args])


FB_OUTPUT
