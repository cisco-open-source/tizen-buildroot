#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=c-ares

cross_configure_make $PACKAGE_NAME "--host=$HOST \
 --enable-symbol-hiding --enable-nonblocking --enable-shared --disable-static --with-pic"
 