#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=c-ares

export NEED_AUTORECONF=1
export PRECONFIG="unset LIBS && unset CFLAGS"
cross_configure_make $PACKAGE_NAME "--host=$HOST \
 --enable-symbol-hiding --enable-nonblocking --enable-shared --disable-static --with-pic"
 