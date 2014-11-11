#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=diffutils
export NEED_AUTORECONF=1
cross_configure_make $PACKAGE_NAME "--host=$HOST \
    gl_cv_warn_c__Werror=no --disable-nls"