#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libarchive
cross_configure_make $PACKAGE_NAME " --host=$HOST --disable-static --enable-bsdcpio"