#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=gdbm
cross_configure_make $PACKAGE_NAME "--host=$HOST --enable-libgdbm-compat --disable-nls"