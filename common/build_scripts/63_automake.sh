#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=automake

export PRECONFIG="sed -i.back -e 's:include \$(srcdir)/doc/Makefile.inc::g' Makefile.am && \
	./bootstrap.sh"
	
cross_configure_make $PACKAGE_NAME "--host=$HOST" 