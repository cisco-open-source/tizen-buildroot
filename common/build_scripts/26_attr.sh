#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=attr

export DIST_ROOT=$BUILD_ROOT
export NO_MAKE_INSTALL=1
export POSTINSTALL="make install && make install-dev && make install-lib"

cross_configure_make $PACKAGE_NAME "--host=$HOST --enable-gettext=no --with-pic" $PACKAGE_NAME
