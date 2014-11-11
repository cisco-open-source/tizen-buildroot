#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=git

# this fix needs double check to confirm this fix, else move back to fix with moving tar.h file
export CFLAGS="-iquote $TIZEN_PKG_DIR/$PACKAGE_NAME"
# mv $BUILD_PREFIX/include/tar.h $BUILD_PREFIX/include/tar.hh
# mv $BUILD_PREFIX/include/tar.hh $BUILD_PREFIX/include/tar.h

cross_configure_make  $PACKAGE_NAME "--host=$HOST  ac_cv_fread_reads_directories=yes \
    ac_cv_snprintf_returns_bogus=yes" 

