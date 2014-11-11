#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=libtool

if [ $PROFILE = "mipsel" ]; then 
	export POSTINSTALL="sed -i.back -e 's:$TOOLS_PATH:/usr:g' libtool  &&\
		sed -i.back -e 's:bin/mipsel-linux-:bin/:g'  libtool  &&\
		sed -i.back -e 's:$BUILD_PREFIX:/usr:g' libtool  &&\
	    cp libtool $BUILD_ROOT/bin/"
fi

cross_configure_make $PACKAGE_NAME "--host=$HOST"


export PACKAGE_NAME=
export POSTINSTALL=