#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libxslt

export NEED_AUTORECONF=1

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --disable-static --with-pic --without-python \
    --with-libxml-include-prefix=$BUILD_PREFIX/include/libxml2"