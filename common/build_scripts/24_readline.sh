#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=readline

if [ $PROFILE = "mipsel" ]; then 
	TARGET_HOST="mipsel-linux"
else
	TARGET_HOST=$HOST
fi

cross_configure_make $PACKAGE_NAME "--host=$TARGET_HOST"