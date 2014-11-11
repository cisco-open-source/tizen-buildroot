#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=nss

print_header $PACKAGE_NAME

if [ $PROFILE = "mipsel" ]; then 
    ARCH="mips"
elif [ $PROFILE = "arm" ]; then 
   ARCH="arm"
fi

prepare_build_dir $PACKAGE_NAME

BUILD_OPT="CPU_ARCH=$ARCH NSS_ENABLE_ECC=1 BUILD_OPT=1 \
    NSS_USE_SYSTEM_SQLITE=1 \
    NS_USE_GCC=1 \
    NSPR_INCLUDE_DIR=$BUILD_PREFIX/include/nspr4 \
    NSPR_LIB_DIR=$BUILD_PREFIX/lib \
    TARGETCC=$CROSS_CC \
    TARGETCCC=$CROSS_CXX \
    TARGETRANLIB=$CROSS_RANLIB \
    NATIVE_CC=gcc \
    LDFLAGS=-Wl,-rpath-link,$BUILD_PREFIX/lib \
    OS_ARCH=Linux \
    CHECKLOC= \
    FREEBL_NO_DEPEND=1 \
    OS_TEST=$ARCH"

patch -Np3 -i $WORK_DIR/common/patches/nss-cross.patch

check_command "make clean" $PACKAGE_NAME

check_command "make -C coreconf $BUILD_OPT" $PACKAGE_NAME

check_command "make nss_build_all $BUILD_OPT OPTIMIZER=$DEFAULT_CFLAGS" $PACKAGE_NAME

install -v -m755 ../dist/Linux*/lib/*.so              $BUILD_PREFIX/lib
install -v -m755 ../dist/Linux*/lib/{*.chk,libcrmf.a} $BUILD_PREFIX/lib
install -v -m755 -d                           $BUILD_PREFIX/include/nss3
install -v -m755 ../dist/{public,private}/nss/* $BUILD_PREFIX/include/nss3
install -v -m644 packaging/nss.pc.in $BUILD_PREFIX/lib/pkgconfig/nss.pc

sed -i.back -e "s:%LIBDIR%:/usr/lib:g
s:%VERSION%:3.16.3:g
s:%NSPR_VERSION%:4.10.2:g" \
   $BUILD_PREFIX/lib/pkgconfig/nss.pc

rm -f  $BUILD_PREFIX/lib/pkgconfig/nss.pc.back

clean_build_dir $PACKAGE_NAME
echo "##################### end of build of $PACKAGE_NAME #################################"