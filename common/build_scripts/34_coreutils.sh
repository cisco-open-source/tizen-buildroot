#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=coreutils

if [ $PROFILE = "mipsel" ]; then 
    export LIBS="$LIBS -lrt"
fi

print_header $PACKAGE_NAME

set_cross_compiler

prepare_build_dir $PACKAGE_NAME

tar -xvf packaging/gnulib.tar.bz2

check_command "./bootstrap --no-git --gnulib-srcdir=gnulib --skip-po --no-bootstrap-sync"

patch -Np1 -i $WORK_DIR/common/patches/coreutils-8.22-noman-1.patch

check_command "./configure --prefix=/usr --host=$HOST \
        --build=i686-linux \
        --without-included-regex \
        --enable-no-install-program=uptime \
        gl_cv_func_printf_directive_n=yes \
        gl_cv_func_isnanl_works=yes \
        DEFAULT_POSIX2_VERSION=199209" $PACKAGE_NAME

cp -v Makefile{,.orig}
sed '/src_make_prime_list/d' Makefile.orig > Makefile
depbase=`echo src/make-prime-list.o | sed 's|[^/]*$|.deps/&|;s|\.o$||'`;\
gcc -std=gnu99  -I. -I./lib  -Ilib -I./lib -Isrc -I./src \
    -fdiagnostics-show-option -funit-at-a-time -g -O2 -MT \
    src/make-prime-list.o -MD -MP -MF $depbase.Tpo -c -o src/make-prime-list.o \
    src/make-prime-list.c &&
mv -f $depbase.Tpo $depbase.Po
gcc -std=gnu99 -fdiagnostics-show-option -funit-at-a-time -g -O2 \
    -Wl,--as-needed  -o src/make-prime-list src/make-prime-list.o

#Remove the building of the hostname man page as it is affected by the previous commands.
cp -v Makefile{,.bak}
sed -e '/hostname.1/d' Makefile.bak > Makefile

check_command "make -C po update-po" $PACKAGE_NAME
check_command "make V=1 " $PACKAGE_NAME

#if [ -z "$NO_MAKE_INSTALL" ]; then
    check_command "make install DESTDIR=$BUILD_ROOT" $PACKAGE_NAME
#     export NO_MAKE_INSTALL=
# fi

echo "##################### end of build of $1 #################################"

unset_cross_compiler

clean_build_dir $PACKAGE_NAME