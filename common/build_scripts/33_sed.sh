#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=sed
export PRECONFIG="sed -i.back -e 's/SUBDIRS = lib po sed doc testsuite/SUBDIRS = lib po sed testsuite/g' Makefile.in"

cross_configure_make $PACKAGE_NAME  "--host=$HOST \
    --disable-nls --without-included-regex"
