#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=elfutils

export NEED_AUTORECONF=1

if [ $PROFILE = "mipsel" ]; then
	export LDFLAGS="-lintl"
	DISABLE_PROGS="--disable-progs"
	PATCHES="elfutils-01-disable-progs.patch\
	    elfutils-02-argp-support.patch\
	    elfutils-03-memcpy-def.patch"
fi

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --program-prefix=eu- --disable-werror $DISABLE_PROGS"
