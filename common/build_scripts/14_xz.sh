#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=xz
cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --disable-static --with-pic"