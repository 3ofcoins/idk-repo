dnl -*- autoconf -*-

dnl Initialization
dnl ==============

dnl FB_INIT
dnl -------
dnl Initialize Autoconf and self
m4_define([FB_INIT], [
  AC_PREREQ([2.69])
  AC_INIT([foundation], [m4_chomp(m4_esyscmd([git describe]))])
  AC_REVISION([m4_chomp(m4_esyscmd([git describe --long]))])
  _FB_INIT_HELP
  FB_ARG_VAR( [FOUNDATION_ROOT], [Root directory of the Foundation repository],
              [`(cd "$srcdir/../.." ; pwd)`] )
  AC_ARG_VAR([DRY_RUN], [Print out bootstrap commands instead of executing them])
  _fb_pwd=`pwd` ; AC_MSG_NOTICE([in $_fb_pwd])
])dnl FB_INIT

dnl _FB_INIT_HELP
dnl -------------
dnl Override help header to avoid cluttering `./configure --help' with
dnl irrelevant software build options
m4_define([_FB_INIT_HELP],
 [ AC_PRESERVE_HELP_ORDER
   m4_cleardivert([HELP_BEGIN])
   m4_divert_push([HELP_BEGIN])
if test "$ac_init_help" = "long"; then
    cat <<_ACEOF
\`$[0]' configures m4_ifset([AC_PACKAGE_STRING],
                            [AC_PACKAGE_STRING],
                            [this package]) to adapt to many kinds of systems.

Usage: $[0] [[OPTION]]... [[VAR=VALUE]]...

[To assign environment variables (e.g., NAME, FQDN...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print \`checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for \`--cache-file=config.cache'
  -n, --no-create         do not create output files or run bootstrap script
      --srcdir=DIR        find the sources in DIR [configure dir or \`..']
]
m4_divert_pop([HELP_BEGIN])])dnl _FB_INIT_HELP

dnl Definitions
dnl ===========

dnl FB_RUN(COMMAND)
dnl ---------------
AC_DEFUN([FB_RUN],
  [AS_VAR_APPEND([_fb_run_commands], ["AS_ESCAPE([$1], [\"])
"])
])dnl FB_RUN

dnl FB_ARG_VAR(VARNAME, DOCUMENTATION, DEFAULT)
dnl -------------------------------------------
dnl Same as AC_ARG_VAR, but makes it possible to specify default value
AC_DEFUN( [FB_ARG_VAR],
  [ AC_ARG_VAR([$1], [$2])
    m4_ifnblank([$3],
      [ AS_VAR_SET_IF( [$1], [],
          [AC_SUBST([$1], [$3])])])
])dnl FB_ARG_VAR

dnl FB_TRY_PROG(PROG-TO-CHECK-FOR, ACTION-IF-NOT-FOUND)
dnl ---------------------------------------------------
dnl Calls AC_CHECK_PROG and runs ACTION-IF-NOT-FOUND if PROG-TO-CHECK-FOR
dnl was not found. ACTION-IF-NOT-FOUND is most likely FB_RUN with whatever
dnl command will install PROG-TO-CHECK-FOR.
AC_DEFUN([FB_TRY_PROG],[
  AC_CHECK_PROG([_fb_has_prog_]AS_TR_SH($1), [$1], [yes])
  AS_IF([test "x$_fb_has_prog_]AS_TR_SH($1)[" != "xyes"], [$2])])

dnl FB_INSTALL(PACKAGE_NAME)
dnl ------------------------
dnl Install package from Apt in the bootstrap script. Before first
dnl `apt-get' invocation, DEBIAN_FRONTEND is set to `noninteractive',
dnl and `apt-get update' is called.
AC_DEFUN([FB_INSTALL],
  [AS_VAR_APPEND([_fb_install_packages], [" $1"])])

dnl FB_INSTALL_OMNIBUS_CHEF
dnl -----------------------
AC_DEFUN([FB_INSTALL_OMNIBUS_CHEF],
  [ FB_TRY_PROG([curl], [FB_INSTALL([curl])])
    FB_TRY_PROG([bash], [FB_INSTALL([bash])])
    AC_SUBST([INSTALL_CLIENT],
      ['curl -L https://www.opscode.com/chef/install.sh | bash'])
])dnl FB_INSTALL_OMNIBUS_CHEF

dnl FB_OUTPUT
dnl ---------
dnl Finalizes configuration, calls AC_OUTPUT
AC_DEFUN([FB_OUTPUT], 
  [ AS_VAR_SET_IF([_fb_install_packages],
      [ AC_SUBST([INSTALL_PREREQS],
          ["export DEBIAN_FRONTEND=noninteractive ; apt-get update --yes ; apt-get install --yes $_fb_install_packages"]) ]
      [ AC_SUBST([INSTALL_PREREQS], []) ])
    AC_SUBST([CONFIGURE_SYSTEM], ["$_fb_run_commands"])
    AC_CONFIG_FILES([bootstrap.sh], [chmod 0755 bootstrap.sh])
    AC_CONFIG_COMMANDS([bootstrap], [AS_VAR_SET_IF( [DRY_RUN],
                                                    [sed -e '/^$/d' bootstrap.sh],
                                                    [./bootstrap.sh])])
    AC_OUTPUT
])dnl FB_OUTPUT

