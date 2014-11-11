#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=util-linux

export NEED_AUTORECONF=1
export CFLAGS="-I$BUILD_PREFIX/include/ncurses"
export SUID_CFLAGS="-fpie"
export SUID_LDFLAGS="-pie"
export PKG_CONFIG_LIBDIR="$BUILD_PREFIX/lib/pkgconfig"

export POSTINSTALL=" \
    mkdir -p $BUILD_ROOT/etc/pam.d &&\
    mkdir -p $BUILD_ROOT/etc/default &&\
    install -m 644 $TIZEN_PKG_DIR/$PACKAGE_NAME/packaging/su.pamd $BUILD_ROOT/etc/pam.d/su &&\
    install -m 644 $TIZEN_PKG_DIR/$PACKAGE_NAME/packaging/su.pamd $BUILD_ROOT/etc/pam.d/su-l &&\
    install -m 644 $TIZEN_PKG_DIR/$PACKAGE_NAME/packaging/login.pamd $BUILD_ROOT/etc/pam.d/login &&\
    install -m 644 $TIZEN_PKG_DIR/$PACKAGE_NAME/packaging/remote.pamd $BUILD_ROOT/etc/pam.d/remote &&\
    install -m 644 $TIZEN_PKG_DIR/$PACKAGE_NAME/packaging/su.default $BUILD_ROOT/etc/default/su"

if [ $PROFILE = "mipsel" ]; then 
    export PRECONFIG="patch -Np1 -i $WORK_DIR/$PROFILE/patches/util-linux-mipsel-cross.patch" 
fi

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --enable-mesg \
    --enable-partx \
    --disable-kill \
    --enable-write \
    --enable-line \
    --enable-new-mount \
    --enable-login-utils \
    --enable-mountpoint \
    --disable-use-tty-group \
    --disable-static \
    --disable-silent-rules \
    --disable-rpath"