#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=gettext

export PREAUTORECONF="mkdir -p gettext-tools/intl"
export NEED_AUTORECONF=1

if [ $PROFILE = "mipsel" ]; then 
	export LIBS="$LIBS -lrt"
fi

cross_configure_make  $PACKAGE_NAME "--host=$HOST \
    --without-included-gettext --enable-nls --disable-static \
    --enable-shared --with-pic-=yes --disable-csharp --without-libpth-prefix \
    --disable-openmp"
