#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=lzo

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --disable-static \
    --disable-dependency-tracking \
    --enable-shared"