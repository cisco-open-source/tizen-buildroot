tizen-buildroot
===============

####Scripts preparing buildroot directory from scratch, used for Tizen system

1. Create "user_path_config.sh" and edit pathes there (see "user_path_config.example").

2. To create rootfs and build packages for required architecture:

`./build_pkgs.sh mipsel`    
`sudo ./prepare_rootfs.sh mipsel`    
`sudo ./build_rpms.sh mipsel`    
  
You can specify which rpms need to build:
`sudo ./build_rpms.sh mipsel "argp-standalone acl" `

Some required host tools:

	help2man, flex, flex-devel, ncurses-devel, texinfo, texinfo-tex, gettext-devel, rcs, transfig, libtool, autoconf, automake, bison, gperf, libgpg-error-devel, libxml2-devel

By default temporary build directory will be deleted, to save it you should set environment variable:     
 `export DONT_CLEAN=1 ` 
  
*You should update macros.tizen-platform for new snapshot of Tizen (copy it from libtzplatform-config-devel-1.0-0.mipsel.rpm).*
              
**Important:** the bash package v.4.3.30 is working incorrect in chroot, so currently using v.4.2.  
