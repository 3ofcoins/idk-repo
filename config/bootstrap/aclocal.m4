dnl -*- autoconf -*-

m4_define([FB_INIT], [
  AC_PREREQ([2.69])
  AC_INIT([foundation], [m4_chomp(m4_esyscmd([git describe]))])
  AC_REVISION([m4_chomp(m4_esyscmd([git describe --long]))])
  _FB_INIT_HELP
  _FB_INIT_BOOTSTRAP

  AS_VAR_IF( [ac_top_srcdir], [],
             [__fb_configure_dir='.'],
             [__fb_configure_dir="$ac_top_srcdir"] )
  FB_ARG_VAR( [FOUNDATION_ROOT], [Root directory of the Foundation repository],
              [`(cd "$__fb_configure_dir/../.." ; pwd)`] )
])

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
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or \`..']
]
m4_divert_pop([HELP_BEGIN])])

AC_DEFUN([FB_RUN],
  [ AS_ECHO(["AS_ESCAPE([$1], ['\"])"]) >> ./bootstrap.sh.in.tmp ])

m4_define([_FB_INIT_BOOTSTRAP],
  [ cat > ./bootstrap.sh.in.tmp <<_FB_EOF
#!/bin/sh
set -e -x
_FB_EOF

    AC_CONFIG_COMMANDS_PRE([
      AC_CONFIG_FILES( [bootstrap.sh],
                       [chmod 0755 bootstrap.sh ; rm $srcdir/bootstrap.sh.in],
                       [cat >$srcdir/bootstrap.sh.in <<_FB_BOOTSTRAP_SH_IN_EOF
`cat ./bootstrap.sh.in.tmp`
_FB_BOOTSTRAP_SH_IN_EOF
rm ./bootstrap.sh.in.tmp])]) ])

AC_DEFUN( [FB_ARG_VAR],
  [ AC_ARG_VAR([$1], [$2])
    m4_ifnblank([$3],
      [ AS_VAR_SET_IF( [$1], [],
          [AC_SUBST([$1], [$3])])])])

AC_DEFUN( [_FB_WOULD],
  [AS_ECHO(["* Would AS_ESCAPE([$1], [`\"])"])])

AC_DEFUN([FB_TRY_PROG],[
  AC_CHECK_PROG([_fb_has_prog_]AS_TR_SH($1), [$1], [yes])
  AS_IF([test "x$_fb_has_prog_]AS_TR_SH($1)[" != "xyes"], [$2])])

AC_DEFUN([FB_INSTALL],
  [ AS_IF( [test "x$_fb_install_apt_configured" = "x"],
           [ FB_RUN([export DEBIAN_FRONTEND=noninteractive])
             FB_RUN([apt-get update --yes]) ])
    _fb_install_apt_configured=yes
    FB_RUN([apt-get install --yes $1]) ])

AC_DEFUN([FB_FILE],
  [ cat > $srcdir/AS_ESCAPE([$1]) <<EOF
AS_ESCAPE(m4_default([$2], [m4_builtin([undivert], [$1.src])]))
EOF])

AC_DEFUN([FB_FILES],
  [m4_map_args([FB_FILE], $@)])

AC_DEFUN([FB_CONFIG_FILE],
  [ AC_CONFIG_FILES([$1], [rm $1.in], [FB_FILE([$1.in], [$2])]) ])

AC_DEFUN([FB_CONFIG_FILES],
  [m4_map_args([FB_CONFIG_FILE], $@)])
