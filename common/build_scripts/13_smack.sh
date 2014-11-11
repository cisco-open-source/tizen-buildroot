#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=smack
export NEED_AUTORECONF=1
cross_configure_make $PACKAGE_NAME "--host=$HOST --disable-nls"