#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=findutils

export PRECONFIG="sed -i.back -e 's/SUBDIRS = gnulib tests build-aux lib find xargs locate doc po m4/SUBDIRS = gnulib tests build-aux lib find xargs locate po m4/g' Makefile.in"

cross_configure_make $PACKAGE_NAME  "--host=$HOST \
   --localstatedir=/var/lib \
   --without-included-regex \
   --without-fts \
   --enable-d_type-optimisation"