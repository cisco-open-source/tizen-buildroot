tizen-buildroot
===============

Scripts preparing buildroot directory from scratch, used for Tizen system

1. Create "user_path_config.sh" and edit pathes there (see "user_path_config.example").

2. Run ./build_pkgs.sh mipsel ( or ./build_pkgs.sh arm ) and follow instructions

3. Run ./prepare_rootfs.sh mipsel ( or ./prepare_rootfs.sh arm ) 

4. To build all rpms for pre-built : 
      sudo ./build_rpms.sh mipsel 
  or: 
      sudo ./build_rpms.sh arm 
  You can specify which rpms need to build:
      sudo ./build_rpms.sh mipsel "argp-standalone acl" 

Some required host tools:
    help2man
    flex-devel
    ncurses-devel
    texinfo  
    texinfo-tex  
    gettext-devel  
    rcs
    transfig


Add new package to build:
-- Create file in common/build_scripts directory in format ##_pgk-name.sh, where ## is sequence number to build;
-- Write needed build commands here. 

For convinience there is cross_configure_make function in utils.sh that perform ./configure make make install sequence.
Usage:
  cross_configure_make pkg-name config-option
pkg-name - name of package to build (should be in your Tizen/platform/upstream directory)
config-option - option for ./configure (Note that --prefix=/usr is default one)

Behaviour of cross_configure_make could be customized by next environment variables:

  PATCHES           - ' ' separated list of patches (assuming that patches is plased in packaging directory)
  NEED_AUTOGEN      - if set run "./autogen.sh"
  NEED_AUTORECONF   - if set run "autoreconf -fi"
  PRECONFIG         - actions that will be perform before "./configure" step
  PREMAKE           - actions that will be perform before "make" step
  PREINSTALL        - actions that will be perform before "make install" step
  POSTINSTALL       - actions that will be perform after "make install" step
  NO_MAKE_INSTALL   - don't run "make install"

  LIBS, LDFLAGS, CFLAGS, CPPFLAGS - additional libs/flags for cross-compilation

You should update macros.tizen-platform for new snapshot of Tizen (copy it from libtzplatform-config-devel-1.0-0.mipsel.rpm).

By default temporary build directory will be deleted, to save it you should set environment variable: 
  export DONT_CLEAN=1                

Important: the bash package v.4.3.30 is working incorrect in chroot, so currently using v.4.2.  