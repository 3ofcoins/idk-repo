#!/bin/sh
set -x
exec ${AUTOCONF:-autoconf} -o bootstrap bootstrap.ac
