#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=patch
cross_configure_make $PACKAGE_NAME "--host=$HOST"