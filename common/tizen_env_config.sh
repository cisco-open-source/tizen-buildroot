#!/usr/bin/env bash

#temporary directory for building packages
export TMP_BUILD_DIR=/var/tmp/build_scripts

export TIZEN_PKG_DIR=$TIZEN_DIR/platform/upstream

export DEFAULT_LDFLAGS="-L$BUILD_PREFIX/lib -Wl,-rpath-link,$BUILD_PREFIX/lib"
export DEFAULT_LIBS=-L$BUILD_PREFIX/lib
export DEFAULT_CFLAGS=-I$BUILD_PREFIX/include
export DEFAULT_CPPFLAGS=-I$BUILD_PREFIX/include
export LD_AS_NEEDED=1

# auxiliary env var which indicate that will be saved or deleted temporary build directory
# by default - it will be deleted.
# export DONT_CLEAN=1