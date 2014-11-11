#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=lua

print_header $PACKAGE_NAME

prepare_build_dir $PACKAGE_NAME

LUA_VERSION=5.1
LUA_BUILDMODE=dynamic
LUA_MYLIBS="-L$BUILD_PREFIX/lib -lreadline -lhistory -lncurses -ldl"
export AR="$CROSS_AR cru"


check_command "make CC=$CROSS_CC RANLIB=$CROSS_RANLIB \
    CFLAGS=-fPIC \
    MYLIBS=\"$LUA_MYLIBS\" \
    BUILDMODE=$LUA_BUILDMODE \
    LIBS=$LUA_MYLIBS \
    V=$LUA_VERSION linux" $PACKAGE_NAME

check_command "make install INSTALL_TOP=$BUILD_PREFIX INSTALL_LIB=$BUILD_PREFIX/lib INSTALL_CMOD=$BUILD_PREFIX/lib/lua/5.1" $PACKAGE_NAME

check_command "install -D -m644 etc/lua.pc $BUILD_PREFIX/lib/pkgconfig/lua.pc" $PACKAGE_NAME

export AR=
clean_build_dir $PACKAGE_NAME