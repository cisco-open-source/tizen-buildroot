#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=file
cross_configure_make $PACKAGE_NAME "--host=$HOST --disable-silent-rules --disable-static --with-pic --enable-fsect-man5"