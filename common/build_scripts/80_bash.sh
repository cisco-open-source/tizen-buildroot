#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=bash

export ADDITIONAL_FLAGS="CPPFLAGS=-D_GNU_SOURCE -DDEFAULT_PATH_VALUE='\"/usr/local/bin:/usr/bin\"' -DRECYCLES_PIDS `getconf LFS_CFLAGS`"

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --enable-largefile \
    --without-bash-malloc \
    --disable-nls \
    --enable-alias \
    --enable-readline \
    --enable-history"