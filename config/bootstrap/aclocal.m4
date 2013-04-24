dnl -*- autoconf -*-

m4_define([FB_INIT], [
  AC_PREREQ([2.69])
  AC_INIT([foundation], [m4_chomp(m4_esyscmd([git describe]))])
  AC_REVISION([m4_chomp(m4_esyscmd([git describe --long]))])
  _FB_INIT_HELP ])

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

[To assign environment variables (e.g., DRY_RUN, FQDN...), specify them as
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

AC_DEFUN( [FB_ARG_VAR],
  [ AC_ARG_VAR([$1], [$2])
    m4_ifnblank([$3],
      [AS_IF( [AS_VAR_TEST_SET([$1])],
              [],
              [AC_SUBST([$1], [$3])])])])

AC_DEFUN( [_FB_IF_DRY],
  [AS_IF( [AS_VAR_TEST_SET([DRY_RUN])], [$1], [$2])])

AC_DEFUN( [_FB_WOULD],
  [AS_ECHO(["* Would AS_ESCAPE([$1], [`\"])"])])

AC_DEFUN( [FB_NEED_ROOT],
  [ _FB_IF_DRY( [_FB_WOULD([make sure script runs as root])],
                [AS_IF([test `whoami` != 'root'],
                       [AC_MSG_ERROR([You need to run this script as root])])])])

AC_DEFUN([FB_COMMAND],
  [_FB_IF_DRY([_FB_WOULD([run: $1])], [$1])])

AC_DEFUN([FB_RUN],
  [AC_CONFIG_COMMANDS([$1], [FB_COMMAND([$2])], [$3])])

AC_DEFUN([FB_TRY_PROG],[
  AC_CHECK_PROG([_fb_has_prog_]AS_TR_SH($1), [$1], [yes])
  AS_IF([test "x$_fb_has_prog_]AS_TR_SH($1)[" != "xyes"], [$2])])

AC_DEFUN([FB_INSTALL],
  [ FB_RUN([install.package.$1], [apt-get install --yes $1]) ])

AC_DEFUN([FB_FILE],
  [ cat > $srcdir/AS_ESCAPE([$1]) <<EOF
AS_ESCAPE(m4_default([$2], [m4_builtin([undivert], [$1.src])]))
EOF
])

AC_DEFUN([FB_FILES],
  [m4_map_args([FB_FILE], $@)])

AC_DEFUN([FB_CONFIG_FILE],
  [ AC_CONFIG_FILES([$1], [rm $1.in], [FB_FILE([$1.in], [$2])]) ])

AC_DEFUN([FB_CONFIG_FILES],
  [m4_map_args([FB_CONFIG_FILE], $@)])
