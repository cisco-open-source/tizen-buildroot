#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=bison

if [ $PROFILE = "mipsel" ]; then 
	export LIBS="$LIBS -lrt"
fi

export PRECONFIG="sed -i.back -e 's/SUBDIRS = build-aux po runtime-po lib data src doc examples tests etc/SUBDIRS = build-aux po runtime-po lib data src examples tests etc/g' Makefile.in"

cross_configure_make $PACKAGE_NAME "--host=$HOST --disable-nls" 