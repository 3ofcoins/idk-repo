#!/bin/sh
set -e

command=$1
shift
cd `dirname $0`

case $command in
    help)
        cat <<EOF
Usage: $0 COMMAND [ARGS...]

COMMAND can be a known task, an installed command, or a Thor task.

Known tasks:
  help -- display this message
  bootstrap -- (re)initializes the repository; safe to run multiple times

EOF
        if [ -d inst/bin ] ; then
            echo 'Installed commands:'
            ls -C inst/bin | expand | sed 's/^/  /'

            echo
            if [ -x inst/bin/thor ] ; then
                echo 'Thor tasks:'
                ./inst/bin/thor list | grep '^thor ' | sed 's/^thor /  /'
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
        [ -f ./inst/bin/$command   ] && exec ./inst/bin/$command "${@}"
        exec ./inst/bin/thor $command "${@}"
esac
