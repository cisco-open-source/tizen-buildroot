#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=cpio

export PRECONFIG="patch -p1 -i $WORK_DIR/common/patches/cpio-fix-stat-redeclaration.patch"

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    ac_cv_prog_cc_c99=no \
    --disable-nls" 