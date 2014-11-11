#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libxml2
cross_configure_make $PACKAGE_NAME " --host=$HOST \
    --disable-static \
    --with-fexceptions \
    --with-history \
    --without-python \
    --enable-ipv6 \
    --with-sax1 \
    --with-regexps \
    --with-threads \
    --with-reader \
    --with-http"    