#!/usr/bin/env bash

source ../utils.sh

PACKAGE_NAME=ncurses

cross_configure_make $PACKAGE_NAME "--host=$HOST \
    --includedir=/usr/include \
    --with-shared --without-ada       \
    --without-debug     \
    --without-profile   \
    --without-manpage-tbl   \
    --with-shared       \
    --with-normal       \
    --with-manpage-format=gzip \
    --with-manpage-aliases  \
    --with-gpm      \
    --with-dlsym        \
    --with-termlib=tinfo    \
    --with-ticlib=tic   \
    --with-xterm-kbs=del    \
    --disable-root-environ  \
    --disable-termcap   \
    --disable-overwrite \
    --disable-rpath     \
    --disable-leaks     \
    --disable-xmc-glitch    \
    --enable-symlinks   \
    --enable-big-core   \
    --enable-const      \
    --enable-hashmap    \
    --enable-no-padding \
    --enable-symlinks   \
    --enable-sigwinch   \
    --enable-pc-files \
    --with-pkg-config \
    --enable-colorfgbg  \
    --enable-sp-funcs   \
    --without-pthread   \
    --disable-reentrant \
    --disable-ext-mouse \
    --disable-widec     \
    --disable-ext-colors    \
    --enable-weak-symbols   \
    --enable-wgetch-events  \
    --enable-pthreads-eintr \
    --enable-string-hacks   \
    --disable-widec     \
    --disable-tic-depends"     