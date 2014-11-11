#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=curl
cross_configure_make $PACKAGE_NAME " --host=$HOST --without-nss \
        --without-gnutls \
        --disable-ipv6 \
        --with-libidn \
        --with-lber-lib=lber \
        --enable-manual \
        --enable-versioned-symbols \
        --enable-debug \
        --enable-curldebug \
        --disable-static \
        --with-openssl \
        --with-ca-path=/etc/ssl/certs"  #        --enable-ares=$TIZEN_DIR/platform/upstream/c-ares \   \