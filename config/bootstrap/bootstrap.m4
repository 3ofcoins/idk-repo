dnl -*- autoconf -*-
dnl 
dnl # Initialization
dnl 
AC_INIT([bootstrap], m4_bpatsubst(m4_esyscmd([git describe]), [\s*$]))
AC_REVISION(m4_bpatsubst(m4_esyscmd([git describe --long]), [\s*$]))
BF_BASENAME=`basename $[]0`
CONFIG_STATUS="./$BF_BASENAME.status"
mv config.log $BF_BASENAME.log
AC_ARG_VAR([DRY_RUN], [Don't actually run anything])
AC_CONFIG_COMMANDS( [initialization],
                    [set -e ; export DEBIAN_FRONTEND=noninteractive])
dnl
dnl FIXME: update help message
dnl
dnl # Macros
dnl

AC_DEFUN( [FB_IF_DRY],
  [AS_IF( [AS_VAR_TEST_SET([DRY_RUN])], [$1], [$2])])

AC_DEFUN( [_FB_WOULD],
  [AS_ECHO(["* Would AS_ESCAPE([$1], [`\"])"])])

AC_DEFUN( [FB_NEED_ROOT],
  [FB_IF_DRY( [_FB_WOULD([make sure script runs as root])],
              [AS_IF([test `whoami` != 'root'],
                     [AC_MSG_ERROR([You need to run this script as root])])])])

AC_DEFUN([FB_COMMAND],
  [FB_IF_DRY([_FB_WOULD([run: $1])], [$1])])
AC_DEFUN([FB_RUN],
  [AC_CONFIG_COMMANDS([$1], [FB_COMMAND([$2])], [$3])])

AC_DEFUN([FB_TRY_PROG],[
  AC_CHECK_PROG([_fb_has_prog_]AS_TR_SH($1), [$1], [yes])
  AS_IF([test "x$_fb_has_prog_]AS_TR_SH($1)[" != "xyes"], [$2])])

AC_DEFUN([FB_INSTALL], [FB_RUN([install.package.$1], [apt-get install --yes $1])])

AC_DEFUN([FB_ARG_FQDN],
  [ AC_ARG_VAR([FQDN], [Desired Fully Qualified Domain Name of the host])
    AS_IF( [AS_VAR_TEST_SET([FQDN])], [AC_SUBST([FQDN],[`hostname -f`])]) ])

FB_RUN([apt-get.update], [apt-get update --yes])
