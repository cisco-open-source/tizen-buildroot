#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libgcrypt

export NEEDAUTORECONF=1

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --with-pic \
    --enable-noexecstack \
    --disable-static"