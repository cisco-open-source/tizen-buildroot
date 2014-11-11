#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=gperf

export PREMAKE="sed -i.back -e '/doc/ d' Makefile"

cross_configure_make $PACKAGE_NAME "--host=$HOST" 