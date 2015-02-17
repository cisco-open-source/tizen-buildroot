#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=xz

export NEED_AUTOGEN=1

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --disable-static --with-pic"