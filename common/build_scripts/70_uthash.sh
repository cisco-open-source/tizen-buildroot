#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=uthash

prepare_build_dir $PACKAGE_NAME

cd src

cp utarray.h uthash.h utlist.h utstring.h $BUILD_PREFIX/include/

clean_build_dir $PACKAGE_NAME

echo "##################### end of build of $PACKAGE_NAME #################################"