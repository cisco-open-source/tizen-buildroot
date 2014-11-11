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

#set -x
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $WORK_DIR/user_path_config.sh
if [ $? -ne 0 ]; then 
    echo "You must create user_path_config.sh with coresponding values"
    echo "See user_path_config.example"
    exit
fi 

source $WORK_DIR/common/tizen_env_config.sh

export PROFILE=$1
if [ -z $PROFILE ]; then 
    echo "############### You should specify architecture to build ... ################"
    echo "### e.g.: ./build_rpms.sh mipsel , or ./build_rpms.sh arm ###"    
    exit
fi

source $WORK_DIR/$PROFILE/arch_config.sh

if [ $PROFILE = "mipsel" ]; then 
    PROFILE_DEFINES="--target mipsel --define '_with_uclibc 1'"
elif [ $PROFILE = "arm" ]; then 
    PROFILE_DEFINES="--target armv7hl"
fi


echo "##########################################################"
echo "##### You are building rpms for profile $PROFILE ... #####"
echo "##########################################################"

if [ -z $2 ]; then
    RPM_LIST=$(cat $WORK_DIR/common/rpm_list.txt)
else
    RPM_LIST=$2
fi

TOTAL=0
FAILED=0
SUCCESS=0
FAILED_RPM=""

LOGS_DIR=$BUILD_ROOT/usr/src/logs
FAILED_LOGS_DIR=$LOGS_DIR/failed
SUCCESS_LOGS_DIR=$LOGS_DIR/success
SRPM_DIR=/home/abuild/prebuild_srpms

$WORK_DIR/common/do_qemu.sh $PROFILE

mkdir -p $FAILED_LOGS_DIR
mkdir -p $SUCCESS_LOGS_DIR

for RPM in $RPM_LIST
do
    TOTAL=$((TOTAL+1))
    echo
    echo "##########################################################"
    echo "##### You are building package $RPM ... #####"
    echo "##########################################################"
    gbs export --source-rpm -o $BUILD_ROOT$SRPM_DIR $TIZEN_PKG_DIR/$RPM
    
    STATUS=$?
    if [ $STATUS -ne 0 ]; then 
        echo "############### export source-rpm $RPM is wrong ... ######################"
        FAILED=$((FAILED+1))
        FAILED_RPM="$FAILED_RPM $RPM"
        break
    fi 

    rm $BUILD_ROOT/home/abuild/status.txt

    chroot $BUILD_ROOT /bin/bash -c "FORCE_UNSAFE_CONFIGURE=1 rpmbuild --rebuild --nodeps --nocheck \
     --define '_without_gbs 1' --define 'do_profiling 0' $PROFILE_DEFINES \
      $SRPM_DIR/$RPM-*/$RPM-*.src.rpm && touch /home/abuild/status.txt " 2>&1 | tee $RPM.log

    if [ -e $BUILD_ROOT/home/abuild/status.txt ]; then 
        SUCCESS=$((SUCCESS+1))
        mv $RPM.log $SUCCESS_LOGS_DIR
    else
        echo "############### rpmbuild $RPM is wrong ... #######################"
        FAILED=$((FAILED+1))
        FAILED_RPM="$FAILED_RPM $RPM"
        mv $RPM.log $FAILED_LOGS_DIR
    
    fi 
done

echo "#########################################################"
echo "##################### Build Status ######################"
echo "Total Packages: $TOTAL"
echo "Succeeded Packages: $SUCCESS "
echo "Failed packeges: $FAILED : $FAILED_RPM"
echo "---------------------------------------------------------"
echo "Source generated to $BUILD_ROOT$SRPM_DIR"
echo "Packages built to $BUILD_ROOT/usr/src/packages/RPMS"
echo "Logs written to $LOGS_DIR"
echo "#########################################################"