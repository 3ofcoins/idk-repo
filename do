#!/bin/sh
set -e

basedir=`dirname $0`
command=$1
shift
export PATH=$basedir/bin:$PATH

case $command in
    help)
        cat <<EOF
Usage: $0 COMMAND [ARGS...]

COMMAND can be a known task, an installed command, or a Thor task.

Known tasks:
  help -- display this message
  bootstrap -- (re)initializes the repository; safe to run multiple times

EOF
        if [ -d $basedir/inst/bin ] ; then
            echo 'Installed commands:'
            ls -C $basedir/inst/bin | expand | sed 's/^/  /'

            echo
            if [ -x $basedir/inst/bin/thor ] ; then
                echo 'Thor tasks:'
                $basedir/inst/bin/thor list | grep '^thor ' | sed 's/^thor /  /'
            else
                echo "Thor doesn't seem to be installed, run \`$0 bootstrap'."
            fi
        else
            echo "Repository is empty, run \`$0 bootstrap' to initialize it."
        fi
        ;;
    bootstrap)
        bundle install
        exec bundle exec thor repo:setup
        ;;
    *)
        [ -f $basedir//inst/bin/$command ] \
            && exec $basedir//inst/bin/$command "${@}"
        exec $basedir//inst/bin/thor $command "${@}"
esac
