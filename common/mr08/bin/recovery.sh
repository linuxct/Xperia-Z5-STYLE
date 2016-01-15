#!/sbin/busybox sh

# set path
export PATH=/sbin:/system/xbin:/system/bin
BUSYBOX="/sbin/busybox"

${BUSYBOX} mount -o remount,rw rootfs /
${BUSYBOX} rm /cache/recovery/boot

# Stop init services.
for SVCNAME in $(getprop | ${BUSYBOX} grep -E '^\[init\.svc\..*\]: \[running\]' | ${BUSYBOX} sed 's/\[init\.svc\.\(.*\)\]:.*/\1/g;'); do
	if [ "${SVCNAME}" != "" -a "${SVCNAME}" != "adbd" ]; then
		stop ${SVCNAME}
	fi
done

# Preemptive strike against locking applications
for LOCKINGPID in `${BUSYBOX} lsof | ${BUSYBOX} awk '{print $1" "$2}' | ${BUSYBOX} grep "/sbin\|/bin\|/system\|/data\|/cache" | ${BUSYBOX} grep -v "adbd\|recovery.sh\|busybox" | ${BUSYBOX} awk '{print $1}'`; do
	BINARY=$(${BUSYBOX} cat /proc/${LOCKINGPID}/status | ${BUSYBOX} grep -i "name" | ${BUSYBOX} awk -F':\t' '{print $2}')
	if [ "$BINARY" != "" ]; then
		${BUSYBOX} killall $BINARY
	fi
done

${BUSYBOX} sync

## /system
${BUSYBOX} umount -l /dev/block/mmcblk0p26
## /data
${BUSYBOX} umount -l /dev/block/mmcblk0p29
## /cache
${BUSYBOX} umount -l /dev/block/mmcblk0p27

${BUSYBOX} umount -l /data		# Userdata
${BUSYBOX} umount -l /sdcard		# SDCard
${BUSYBOX} umount -l /storage/sdcard	# SDCard
${BUSYBOX} umount -l /storage/sdcard1	# SDCard1
${BUSYBOX} umount -l /cache		# Cache
${BUSYBOX} umount -l /system		# System

# External USB umountpoint
${BUSYBOX} umount /mnt/usbdisk
${BUSYBOX} umount /usbdisk
${BUSYBOX} umount /storage/usbdisk

${BUSYBOX} sync

echo 0 > /sys/class/leds/rgb_blue/brightness
echo 0 > /sys/class/leds/rgb_red/brightness
echo 0 > /sys/class/leds/rgb_green/brightness
echo 0x0 > /sys/class/illumination/0
echo 0x0 > /sys/class/illumination/6
echo 0x0 > /sys/class/illumination/7
echo 0x0 > /sys/class/illumination/8
echo 0x0 > /sys/class/illumination/4

# cd to root fs
cd /
${BUSYBOX} rm -rf etc init* uevent* default* sdcard
${BUSYBOX} cpio -i -u < /sbin/recovery.cpio


# Execute recovery INIT
exec /init

# reboot if error occurs
reboot
