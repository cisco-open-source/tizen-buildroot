#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=gmp

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --enable-mpbsd --enable-cxx"