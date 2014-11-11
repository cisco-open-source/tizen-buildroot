#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libgpg-error

export NEEDAUTORECONF=1

export PRECONFIG="patch -Np1 -i $WORK_DIR/$PROFILE/patches/lock-obj-pub-arch.patch" 

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --with-pic \
    --disable-static"