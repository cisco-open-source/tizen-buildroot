#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=automake

export PRECONFIG="patch -Np1 -i $WORK_DIR/common/patches/automake-remove-doc.patch && \
	./bootstrap.sh"

cross_configure_make $PACKAGE_NAME "--host=$HOST" 