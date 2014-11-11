#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=ppl

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --enable-shared --with-pic --disable-rpath \
    --disable-watchdog"