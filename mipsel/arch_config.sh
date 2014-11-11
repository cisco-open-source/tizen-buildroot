#!/usr/bin/env bash

export BUILD_ROOT=$BUILD_ROOT_LOCATION/mipsel_rootfs
export BUILD_PREFIX=$BUILD_ROOT/usr

#cross compilation
export TOOLS_PATH=$MIPS_PATH
export TOOLS_PREFIX=$TOOLS_PATH/bin/mipsel-linux
export CROSS_CC=$TOOLS_PREFIX-gcc
export CROSS_CXX=$TOOLS_PREFIX-g++
export CROSS_AR=$TOOLS_PREFIX-ar
export CROSS_RANLIB=$TOOLS_PREFIX-ranlib

export DEFAULT_LDFLAGS="-L$BUILD_PREFIX/lib -Wl,-rpath-link,$BUILD_PREFIX/lib"
export DEFAULT_LIBS=-L$BUILD_PREFIX/lib
export DEFAULT_CFLAGS=-I$BUILD_PREFIX/include
export DEFAULT_CPPFLAGS=-I$BUILD_PREFIX/include

export HOST="mipsel-tizen-linux-gnu"
