#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=texinfo
export LD_AS_NEEDED=0
export PREMAKE="make -C tools/gnulib/lib && make -C tools"

cross_configure_make $PACKAGE_NAME "--host=$HOST" 
export LD_AS_NEEDED=1