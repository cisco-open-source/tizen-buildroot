#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=zlib
cross_configure_make $PACKAGE_NAME "--shared"