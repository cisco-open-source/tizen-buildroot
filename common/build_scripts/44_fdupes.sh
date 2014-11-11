#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=fdupes

print_header $PACKAGE_NAME

set_cross_compiler

prepare_build_dir $PACKAGE_NAME


check_command "make clean" $PACKAGE_NAME

sed -i.back -e 's/	gcc fdupes.c/	$(CC) fdupes.c/g' Makefile

check_command "make" $PACKAGE_NAME

install -D -m755 fdupes $BUILD_PREFIX/bin/fdupes
install -D -m644 fdupes.1 $BUILD_ROOT/usr/share/man/man1/fdupes.1
install -D -m644 packaging/macros.fdupes $BUILD_ROOT/etc/rpm/macros.fdupes


echo "##################### end of build of $PACKAGE_NAME #################################"

unset_cross_compiler

clean_build_dir $PACKAGE_NAME
