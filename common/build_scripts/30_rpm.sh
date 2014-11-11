#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=rpm

print_header $PACKAGE_NAME

export echo=echo
# export CFLAGS="-I$BUILD_PREFIX/include/linux"
export CPPFLAGS="-I$BUILD_PREFIX/include/nspr4 -I$BUILD_PREFIX/include/nss3"
export PKG_CONFIG_PATH="$BUILD_PREFIX/lib/pkgconfig"

set_cross_compiler

prepare_build_dir $PACKAGE_NAME

#utar db
tar xvf ./packaging/db-4.8.30.tar.bz2
ln -s db-4.8.30 db
chmod -R u+w db/*
rm -f rpmdb/db.h
patch -p0 -i packaging/db-4.8.30-integration.dif

patch -Np1 -i $WORK_DIR/common/patches/rpm-fix-language-pkg-build.patch
if [ $PROFILE = "arm" ]; then
	export LDFLAGS="$LDFLAGS -L$BUILD_PREFIX/lib -lnss3"
fi

check_command "autoreconf -fi" $PACKAGE_NAME

check_command "./configure --prefix=/usr --host=$HOST \
    --disable-dependency-tracking \
    --sysconfdir=/etc --localstatedir=/var --with-lua \
    --with-acl --enable-shared --with-vendor=tizen " $PACKAGE_NAME

check_command "make clean" $PACKAGE_NAME

check_command "make" $PACKAGE_NAME
sed -i.back -e "s:$TOOLS_PREFIX-:/usr/bin/:g" \
   macros

check_command "make install DESTDIR=$BUILD_ROOT" $PACKAGE_NAME

cp -a packaging/rpm-tizen_macros $BUILD_ROOT/usr/lib/rpm/tizen_macros
mkdir -p $BUILD_ROOT/usr/lib/rpm/tizen
install -m 755 packaging/find-docs.sh $BUILD_ROOT/usr/lib/rpm/tizen
ln -s ../tizen_macros $BUILD_ROOT/usr/lib/rpm/tizen/macros

echo "##################### end of build of $PACKAGE_NAME #################################"
    
unset_cross_compiler 

clean_build_dir $PACKAGE_NAME
