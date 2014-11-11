#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=m4

if [ $PROFILE = "mipsel" ]; then
	export LIBS="$LIBS -lrt"
fi

export PRECONFIG="sed -i.back -e 's/SUBDIRS = . examples lib src doc checks tests/SUBDIRS = . examples lib src checks tests/g' Makefile.in"

cross_configure_make $PACKAGE_NAME "--host=$HOST \
        --without-included-regex \
        gl_cv_func_isnanl_works=yes \
        gl_cv_func_printf_directive_n=yes"