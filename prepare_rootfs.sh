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

PROFILE=$1
if [ -z $PROFILE ]; then 
    echo "####################### You should specify architecture ... ###############################"
    echo "### e.g.: ./untar.sh mipsel , or ./untar.sh arm ###"    
    exit
fi 

source $WORK_DIR/$PROFILE/arch_config.sh

cd $BUILD_ROOT

for RPM in $WORK_DIR/common/pre_rootfs/*.rpm $WORK_DIR/$PROFILE/pre_rootfs/*.rpm
do
	rpm2cpio $RPM | cpio -idmv
	RETVAL=$?
	if [ $RETVAL -ne 0 ]; then 
		echo "################ Failed untar package $RPM #################"
		exit $RETVAL
	fi
done

cd $BUILD_ROOT/usr/bin
ln -s bash sh
