#!/usr/bin/env bash

source ../utils.sh
PACKAGE_NAME=openssl

if [ $PROFILE = "mipsel" ]; then 
      CONFIG_FLAGS="linux-mips"
elif [ $PROFILE = "arm" ]; then 
    CONFIG_FLAGS="linux-elf-arm"
fi

print_header $PACKAGE_NAME

set_cross_compiler

prepare_build_dir $PACKAGE_NAME

export DSO_SCHEME='dlfcn:linux-shared:-fPIC::.so.\$(SHLIB_MAJOR).\$(SHLIB_MINOR)::'
cat <<EOF_ED | ed -s Configure
/^);
-
i
#
# local configuration added from specfile
# ... MOST of those are now correct in openssl's Configure already,
# so only add them for new ports!
#
#config-string,  $cc:$cflags:$unistd:$thread_cflag:$sys_id:$lflags:$bn_ops:$cpuid_obj:$bn_obj:$des_obj:$aes_obj:$bf_obj:$md5_obj:$sha1_obj:$cast_obj:$rc4_obj:$rmd160_obj:$rc5_obj:$wp_obj:$cmll_obj:$dso_scheme:$shared_target:$shared_cflag:$shared_ldflag:$shared_extension:$ranlib:$arflags:$multilib
#"linux-elf",    "gcc:-DL_ENDIAN            ::-D_REENTRANT::-ldl:BN_LLONG \${x86_gcc_des} \${x86_gcc_opts}:\${x86_elf_asm}:$DSO_SCHEME:",
#"linux-ia64",   "gcc:-DL_ENDIAN    -DMD32_REG_T=int::-D_REENTRANT::-ldl:SIXTY_FOUR_BIT_LONG RC4_CHUNK RC4_CHAR:\${ia64_asm}:       $DSO_SCHEME:",
#"linux-ppc",    "gcc:-DB_ENDIAN            ::-D_REENTRANT::-ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_RISC1 DES_UNROLL:\${no_asm}:       $DSO_SCHEME:",
#"linux-ppc64",  "gcc:-DB_ENDIAN -DMD32_REG_T=int::-D_REENTRANT::-ldl:RC4_CHAR RC4_CHUNK DES_RISC1 DES_UNROLL SIXTY_FOUR_BIT_LONG:\${no_asm}:   $DSO_SCHEME:64",
"linux-elf-arm","gcc:-DL_ENDIAN         ::-D_REENTRANT::-ldl:BN_LLONG:\${no_asm}:                           $DSO_SCHEME:",
"linux-mips",   "gcc:-DB_ENDIAN         ::-D_REENTRANT::-ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_RISC1 DES_UNROLL:\${no_asm}:       $DSO_SCHEME:",
"linux-sparcv7","gcc:-DB_ENDIAN         ::-D_REENTRANT::-ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_UNROLL BF_PTR:\${no_asm}:          $DSO_SCHEME:",
#"linux-sparcv8","gcc:-DB_ENDIAN -DBN_DIV2W -mv8    ::-D_REENTRANT::-ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_UNROLL BF_PTR::asm/sparcv8.o:::::::::::::  $DSO_SCHEME:",
#"linux-x86_64", "gcc:-DL_ENDIAN -DNO_ASM -DMD32_REG_T=int::-D_REENTRANT::-ldl:SIXTY_FOUR_BIT_LONG:\${no_asm}:                      $DSO_SCHEME:64",
#"linux-s390",   "gcc:-DB_ENDIAN            ::(unknown):   :-ldl:BN_LLONG:\${no_asm}:                           $DSO_SCHEME:",
#"linux-s390x",  "gcc:-DB_ENDIAN -DNO_ASM -DMD32_REG_T=int::-D_REENTRANT::-ldl:SIXTY_FOUR_BIT_LONG:\${no_asm}:                  $DSO_SCHEME:64",
"linux-parisc", "gcc:-DB_ENDIAN         ::-D_REENTRANT::-ldl:BN_LLONG RC4_CHAR DES_PTR DES_UNROLL DES_RISC1:\${no_asm}:         $DSO_SCHEME:",
.
wq
EOF_ED

# sed -i.back -e 's/SUBDIRS = . examples lib src doc checks tests/SUBDIRS = . examples lib src checks tests/g' $TIZEN_PKG_DIR/$PACKAGE_NAME/Makefile.in

check_command "./Configure          $CONFIG_FLAGS \
            --prefix=/usr \
            --openssldir=/etc/ssl \
            --libdir=/lib \
            -fPIC \
            shared \
            no-idea \
            no-rc5 \
            enable-camellia \
            enable-mdc2 \
            enable-tlsext" $PACKAGE_NAME

check_command "make clean" $PACKAGE_NAME

check_command "make" $PACKAGE_NAME

check_command "make INSTALL_PREFIX=$BUILD_ROOT install" $PACKAGE_NAME

echo "##################### end of build of $PACKAGE_NAME #################################"
    
unset_cross_compiler 

clean_build_dir $PACKAGE_NAME