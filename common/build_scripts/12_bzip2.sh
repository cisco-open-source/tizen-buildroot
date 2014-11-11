#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=bzip2

export NEED_AUTORECONF=1

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    -with-pic --disable-static"