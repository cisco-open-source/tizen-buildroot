#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=pkg-config

cross_configure_make $PACKAGE_NAME   "--host=$HOST \
    --with-pc_path=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig \
    --with-internal-glib glib_cv_stack_grows=no glib_cv_uscore=no \
    ac_cv_func_posix_getpwuid_r=no ac_cv_func_posix_getgrgid_r=no"