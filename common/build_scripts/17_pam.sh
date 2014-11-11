#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=pam

export NEED_AUTORECONF=1
export SAVED_DEFAULT_CFLAGS=$DEFAULT_CFLAGS
export SAVED_DEFAULT_CPPFLAGS=$DEFAULT_CPPFLAGS
export DEFAULT_CFLAGS=
export DEFAULT_CPPFLAGS=
export LIBSMACK_CFLAGS=-I$BUILD_PREFIX/include
export LIBSMACK_LIBS="-lsmack"
export PRECONFIG="sed -i.back -e 's/SUBDIRS = libpam tests libpamc libpam_misc modules po conf doc examples xtests/SUBDIRS = libpam tests libpamc libpam_misc modules po conf examples xtests/g' Makefile.in"

if [ $PROFILE = "mipsel" ]; then
	export CFLAGS="$CFLAGS -lintl"
	export PATCHES="linux-pam-03-group.patch \
    	linux-pam-05-succeed.patch linux-pam-06-time.patch"
fi

cross_configure_make  $PACKAGE_NAME "--includedir=/usr/include/security \
    --host=$HOST \
    --disable-audit \
    --with-db-uniquename=_pam \
    --enable-read-both-confs"

export DEFAULT_CFLAGS=$SAVED_DEFAULT_CFLAGS
export DEFAULT_CPPFLAGS=$SAVED_DEFAULT_CPPFLAGS