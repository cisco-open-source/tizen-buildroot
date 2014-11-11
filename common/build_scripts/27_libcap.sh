#!/usr/bin/env bash
source ../utils.sh
PACKAGE_NAME=libcap

print_header $PACKAGE_NAME

prepare_build_dir $PACKAGE_NAME

if [ $PROFILE = "mipsel" ]; then
	patch -Np1 -i $WORK_DIR/$PROFILE/patches/libcap-01-build-system.patch
elif [ $PROFILE = "arm" ]; then
	BUILDFLAGS="CFLAGS=-I$BUILD_PREFIX/include"
fi

check_command "make clean" $PACKAGE_NAME

check_command "make V=1 BUILD_CC=gcc \
    LIBATTR=yes CC=$CROSS_CC $BUILDFLAGS LDFLAGS=-L$BUILD_PREFIX/lib AR=$CROSS_AR RANLIB=$CROSS_RANLIB" $PACKAGE_NAME

check_command "make install DESTDIR=$BUILD_ROOT \
    LIBDIR=$BUILD_PREFIX/lib RAISE_SETFCAP=no" $PACKAGE_NAME

echo "##################### end of build of $PACKAGE_NAME #################################"

clean_build_dir $PACKAGE_NAME