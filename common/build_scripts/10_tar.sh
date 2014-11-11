#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=tar
cross_configure_make $PACKAGE_NAME "--host=$HOST \
    gl_cv_func_linkat_follow=\"yes\" \
    --disable-silent-rules \
    --disable-nls"