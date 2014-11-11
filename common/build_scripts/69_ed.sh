#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=ed

cross_configure_make $PACKAGE_NAME "CC=$CROSS_CC"