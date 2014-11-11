#!/usr/bin/env bash

source ../utils.sh
export PACKAGE_NAME=nspr

export SAVED_DEFAULT_CFLAGS=$DEFAULT_CFLAGS
export SAVED_DEFAULT_CPPFLAGS=$DEFAULT_CPPFLAGS
export DEFAULT_CFLAGS=
export DEFAULT_CPPFLAGS=

export NO_MAKE_INSTALL=1
export POSTINSTALL="mkdir -p $BUILD_PREFIX/lib/nspr &&\
    mkdir -p $BUILD_PREFIX/include/nspr4 &&\
    cp config/nspr-config $BUILD_PREFIX/bin/  &&\
    cp config/nspr.pc $BUILD_PREFIX/lib/pkgconfig  &&\
    cp -L dist/lib/*.so $BUILD_PREFIX/lib  &&\
    cp -L dist/lib/*.a  $BUILD_PREFIX/lib/nspr/  &&\
    cp -rL dist/include/nspr/* $BUILD_PREFIX/include/nspr4/"



cross_configure_make  $PACKAGE_NAME "--target=$HOST --build=i686-linux --includedir=/usr/include/nspr4"


export PACKAGE_NAME=
export DEFAULT_CFLAGS=$SAVED_DEFAULT_CFLAGS
export DEFAULT_CPPFLAGS=$SAVED_DEFAULT_CPPFLAGS