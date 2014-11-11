#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libxslt

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --disable-static --with-pic --without-python \
    --with-libxml-include-prefix=$BUILD_PREFIX/include/libxml2"