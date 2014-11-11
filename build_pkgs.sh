#!/usr/bin/env bash
############################################################################
## 
##  Copyright © 1992-2014 Cisco and/or its affiliates. All rights reserved.
##  All rights reserved.
##  
##  $CISCO_BEGIN_LICENSE:APACHE$
## 
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##  http://www.apache.org/licenses/LICENSE-2.0
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
## 
##  $CISCO_END_LICENSE$
## 
############################################################################ 

#just for debuging
#set -x

export WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $WORK_DIR/user_path_config.sh
if [ $? -ne 0 ]; then 
    echo "You must create user_path_config.sh with coresponding values"
    echo "See user_path_config.example"
    exit
fi 

source $WORK_DIR/common/tizen_env_config.sh

export PROFILE=$1
if [ -z $PROFILE ]; then 
    echo "####################### You should specify architecture to build ... ###############################"
    echo "### e.g.: ./build_pkgs.sh mipsel , or ./build_pkgs.sh arm ###"    
    exit
fi 

echo "#################################################"
echo "##### You are building profile $PROFILE ... #####"
echo "#################################################"

source $WORK_DIR/$PROFILE/arch_config.sh

if [ ! -e $BUILD_ROOT ]; then
    mkdir -p $BUILD_ROOT
    sudo tar -C $BUILD_ROOT -xvf $WORK_DIR/common/pre_rootfs/rootfs.tgz --strip-components=1

    cd $BUILD_ROOT
    sudo chown -R $USER:$USER $BUILD_ROOT

    chmod 755 $BUILD_ROOT/usr/lib
    chmod 755 $BUILD_ROOT/usr/bin
    chmod 755 $BUILD_ROOT/usr/lib/pkgconfig
    chmod 755 $BUILD_ROOT/usr/sbin
    chmod 755 $BUILD_ROOT/usr/lib/tls
    cd $WORK_DIR
fi

echo "Hello! I could build next packages:"
echo

cd $WORK_DIR/common/build_scripts/
SCRIPT_LIST=$(ls *.sh | sort -k1 -t"_" -n)

# show all availible packages
for f in $SCRIPT_LIST
do
    IFS='_' read -a array <<< "$f"
    filename="${array[1]%.*}"
    echo "${array[0]}   $filename"
done

echo "###################################"
echo "0 - (default) Build all"
echo "1 - Build one package"
echo "2 - Build packages starting from specified package"
echo "Please enter you choice [0]"

LIST_OF_SCRIPT=(${SCRIPT_LIST// /})

for s in ${LIST_OF_SCRIPT[@]}
do
    k=${s%_*}
    BUILD_SCRIPT_LIST[$k]=$s
done

read RESULT

case $RESULT in

    "0"|"")
        echo "Build all packages"
        BUILD_SCRIPT_NEED_BUILD=${BUILD_SCRIPT_LIST[@]}
        ;;

    "1" )
        echo "Build one package" 
        echo "Please enter number of package to build:"
        read PKG_NUM
        BUILD_SCRIPT_NEED_BUILD=${BUILD_SCRIPT_LIST[$PKG_NUM]}
        ;;

    "2" )
        echo "Build packages starting from specified package" 
        echo "Please enter number of package:"
        read PKG_NUM
        BUILD_SCRIPT_NEED_BUILD=${BUILD_SCRIPT_LIST[@]:$PKG_NUM}
        ;;
    *) 
        echo "Wrong choice. Exit"
        exit;;

esac

for f in ${BUILD_SCRIPT_NEED_BUILD[@]}
do
    source "$f" 
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then 
        echo "####################### source $f is wrong ... ###############################"
        break
    fi 
done 2>&1 | tee $WORK_DIR/build_pkgs_$PROFILE.log

cp $WORK_DIR/common/macros.tizen-platform $BUILD_ROOT/etc/rpm/

