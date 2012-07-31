#!/bin/sh

#Convert2SD TWRP by Racks11479

TW_FILENAME=$1

mkdir -p /tmp/c2sd/rd
busyboxracks unzip $TW_FILENAME ramdisk.img -d /tmp/c2sd
busyboxracks unzip $TW_FILENAME META-INF/com/google/android/updater-script -d /tmp/c2sd
busyboxracks unzip $TW_FILENAME system/etc/vold.fstab -d /tmp/c2sd
cd /tmp/c2sd/rd
		
dd if=../ramdisk.img bs=64 skip=1 | gunzip -c | cpio -i

INIT=init.encore.rc
sed -i 's/mmcblk0p5/mmcblk1p2/' $INIT 
sed -i 's/mmcblk0p6/mmcblk1p3/' $INIT

cd /tmp/c2sd
		
rm ramdisk.img
mkbootfs rd | gzip > nuRamdisk-new.gz
mkimage -A ARM -T RAMDisk -n Image -d nuRamdisk-new.gz ramdisk.img
rm -r rd
rm nuRamdisk-new.gz

INIT=META-INF/com/google/android/updater-script
sed -i 's/mmcblk0p5/mmcblk1p2/' $INIT
sed -i 's/mmcblk0p1/mmcblk1p1/' $INIT

INIT=system/etc/vold.fstab
sed -i 's/sdcard auto/sdcard 4/' $INIT
		
zip -ru $TW_FILENAME
