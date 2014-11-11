#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=which

cross_configure_make $PACKAGE_NAME "--host=$HOST"