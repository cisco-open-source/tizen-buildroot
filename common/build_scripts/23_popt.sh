#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=popt

cross_configure_make $PACKAGE_NAME "--host=$HOST --with-pic --disable-static"