#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=sqlite
export NEED_AUTOGEN=1
cross_configure_make $PACKAGE_NAME  "--host=$HOST"