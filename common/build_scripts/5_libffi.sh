#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libffi

if [ $PROFILE = "mipsel"]; then 
	ARCH="mips"
# TODO: check it
# elif [ $PROFILE = "arm"]; then 
# 	ARCH="arm"
fi

cross_configure_make $PACKAGE_NAME "--with-gcc-arch=$ARCH --host=$HOST"
