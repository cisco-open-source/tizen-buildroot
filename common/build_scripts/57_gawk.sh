#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=gawk

#dirty fix for docs
export PRECONFIG="sed -i.back -e 's/SUBDIRS = . awklib doc po test/SUBDIRS = . awklib po test/g' Makefile.in"

cross_configure_make $PACKAGE_NAME "--host=$HOST --disable-nls"