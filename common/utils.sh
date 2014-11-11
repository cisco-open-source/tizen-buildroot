#!/usr/bin/env bash

function check_command() {
    echo "##################### $1 $2 #############################"
    eval $1
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then 
        echo "####################### $2 ###############################"
        echo "$1 step of $2 failed, would you like to continue?[y/n]"
        read ANSW
        if [ "$ANSW" != "y" ]; then
            echo "exiting..."
            exit
        fi 

    fi
}

function cross_configure_make {
    if [ -z "$1" ]; then
        echo "Please specify package"
        exit
    fi

    print_header $1

    set_cross_compiler

    prepare_build_dir $1

    apply_patches

    run_autogen $1

    run_pre_autoreconf $1
  
    run_autoreconf $1

    run_preconfig_action $1

    check_command "./configure --prefix=/usr $2" $1

    run_premake_action $1

    check_command "make" $1

    run_preinstall_action $1

    if [ -z "$NO_MAKE_INSTALL" ]; then
        check_command "make install DESTDIR=$BUILD_ROOT" $1
    else
        export NO_MAKE_INSTALL=
    fi

    run_postinstall_action $1

    clean_build_dir $1

    echo "##################### end of build of $1 #################################"
  
    unset_cross_compiler
} 

function print_header {
    echo "#####################################################################"
    echo "##################### $1 ########################################"
    echo "#####################################################################"
}

function set_cross_compiler {
    export CC=$CROSS_CC
    export CXX=$CROSS_CXX
    export AR=$CROSS_AR
    export RANLIB=$CROSS_RANLIB

    export LIBS="$DEFAULT_LIBS $LIBS"
    export LDFLAGS="$DEFAULT_LDFLAGS $LDFLAGS"
    export CFLAGS="$DEFAULT_CFLAGS $CFLAGS"
    export CPPFLAGS="$DEFAULT_CPPFLAGS $CPPFLAGS"

    export echo=echo
}

function unset_cross_compiler {
    export CC=
    export CXX=
    export AR=
    export RANLIB=

    export LIBS=
    export LDFLAGS=
    export CFLAGS=
    export CPPFLAGS=
}

function apply_patches {
    if [ -n "$PATCHES" ]; then
        echo PATHES" $PATCHES"
        for p in $PATCHES
        do
            # echo "apply patch"
            patch -Np1 -i packaging/$p
        done
        export PATCHES=
    fi
}

function run_autogen {
    if [ -n "$NEED_AUTOGEN" ]; then
        check_command "./autogen.sh" $1
        export NEED_AUTOGEN=
    fi
}

function run_pre_autoreconf {
    if [ -n "$PREAUTORECONF" ]; then
        check_command "$PREAUTORECONF" $1
        export PREAUTORECONF=
    fi
}

function run_autoreconf {
    if [ -n "$NEED_AUTORECONF" ]; then
        check_command "autoreconf -fi" $1
        export NEED_AUTORECONF=
    fi
}

function run_preconfig_action {
    if [ -n "$PRECONFIG" ]; then
        check_command "$PRECONFIG" $1
        export PRECONFIG=
    fi
}

function run_premake_action {
    if [ -n "$PREMAKE" ]; then
        check_command "$PREMAKE" $1
        export PREMAKE=
    fi
}

function run_preinstall_action {
    if [ -n "$PREINSTALL" ]; then
        check_command "$PREINSTALL" $1
        export PREINSTALL=
    fi
}

function run_postinstall_action {
    if [ -n "$POSTINSTALL" ]; then
        check_command "$POSTINSTALL" $1
        export POSTINSTALL=
    fi
}

function remove_la {
    rm -rf `find $BUILD_PREFIX/lib| grep "\.la$"`
}

function prepare_build_dir {
    export PREW_DIR=$(pwd)
    if [ -z $DONT_CLEAN ]; then
        rm -rf $TMP_BUILD_DIR
    fi
    mkdir -p $TMP_BUILD_DIR
    cd $TIZEN_PKG_DIR/$1
    git archive --format=tar --prefix=$1/ HEAD | (cd $TMP_BUILD_DIR && tar xf - )
    cd $TMP_BUILD_DIR/$1

}

function clean_build_dir {
    cd $PREW_DIR
    if [ -z $DONT_CLEAN ]; then
        rm -rf $TMP_BUILD_DIR
    fi
    remove_la
}
