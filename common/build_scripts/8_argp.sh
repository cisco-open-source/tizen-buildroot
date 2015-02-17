#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=argp-standalone

# Group: uclibc
if [ $PROFILE = "mipsel" ]; then 
	export CFLAGS="-fPIC"

	export PRECONFIG="cd packaging && \
	tar xvzf argp-standalone-1.3_src.tar.gz && \
	cd argp-standalone-1.3 && \
	patch -p1 -i ../argp-standalone-1.3-throw-in-funcdef.patch "

	export NO_MAKE_INSTALL=1
	export POSTINSTALL="install -m 644 libargp.a $BUILD_PREFIX/lib && \
	install -m 644 argp.h $BUILD_PREFIX/include "

	cross_configure_make $PACKAGE_NAME "--host=$HOST"
fi
