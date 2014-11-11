#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=autoconf

export PRECONFIG="sed -i.back -e 's/SUBDIRS = bin . lib doc tests man/SUBDIRS = bin . lib tests man/g' Makefile.in"

cross_configure_make $PACKAGE_NAME  "--host=$HOST"