#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=make

export PRECONFIG="sed -i.back -e 's/SUBDIRS = glob config po doc/SUBDIRS = glob config po/g' Makefile.in"

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --disable-nls \
    make_cv_sys_gnu_glob=no"