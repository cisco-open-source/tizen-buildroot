#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=grep
export NEED_AUTORECONF=1
export WERROR_CFLAGS=" "
cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --disable-silent-rules \
    --without-included-regex \
    gl_cv_warn_c__Werror=no"
