#!/sbin/sh

BUSYBOX=/sbin/busybox

VER=$(${BUSYBOX} awk -F= '/ro.build.version.release/{print $NF}' /system/build.prop)
ANDROIDVER=`${BUSYBOX} echo "$VER 5.0.0" | ${BUSYBOX} awk '{if ($2 != "" && $1 >= $2) print "lollipop"; else print "other"}'` 

if [ "$ANDROIDVER" = "lollipop" ]; then
	if [ ! -f "/system/bin/chargemon.bin" ]; then
		/sbin/busybox mv /system/bin/chargemon /system/bin/chargemon.bin
	fi
fi

if [ "$ANDROIDVER" = "other" ]; then
	if [ ! -f "/system/bin/e2fsck.bin" ]; then
		/sbin/busybox mv /system/bin/e2fsck /system/bin/e2fsck.bin
	fi
fi

CHARGEMON=`/sbin/busybox sed -n 1p /system/bin/chargemon.bin`
if [ "${CHARGEMON}" = "#!/system/xbin/busybox sh" ]; then

        echo "Creating a backup"
        /sbin/busybox cp /tmp/chargemon /system/bin/chargemon.bin
        /sbin/busybox chown 0.0 /system/bin/chargemon.bin
        /sbin/busybox chmod 0755 /system/bin/chargemon.bin

fi

if [ "$ANDROIDVER" = "lollipop" ]; then
	echo "running on 5.1.1"
	/sbin/busybox cp /tmp/script.sh /system/bin/chargemon
	/sbin/busybox chmod 755 /system/bin/chargemon
	/sbin/busybox chown 0.2000 /system/bin/chargemon
fi

if [ "$ANDROIDVER" = "other" ]; then
	echo "running on 4.X"
	/sbin/busybox cp /tmp/script.sh /system/bin/e2fsck
	/sbin/busybox chmod 755 /system/bin/e2fsck
	/sbin/busybox chown 0.2000 /system/bin/e2fsck
fi

echo "finished"
exit 0
