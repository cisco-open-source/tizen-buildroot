#!/bin/bash

set -x

PROFILE=$1

mount proc -t proc /proc

did_mount_it=""

if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
	echo "mounting binfmt_misc"
	mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
	did_mount_it=1
fi

echo "Registering accelerated handler"

if [ $PROFILE = "mipsel" ]; then 
    echo -1 > /proc/sys/fs/binfmt_misc/mipsel
    echo ':mipsel:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x08\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xfe\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/qemu/qemu-mipsel-binfmt:P' > /proc/sys/fs/binfmt_misc/register
elif [ $PROFILE = "arm" ]; then
    echo -1 > /proc/sys/fs/binfmt_misc/arm
    echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfa\xff\xff\xff:/usr/bin/qemu-arm-binfmt:P' > /proc/sys/fs/binfmt_misc/register
fi

if [ $did_mount_it ]; then 
	echo "Unmounting again.";
	umount /proc/sys/fs/binfmt_misc
fi

echo "All done"