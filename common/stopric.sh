#!/sbin/sh

if [ -e /system/etc/init.d/00stop_ric ]; then
	rm /system/etc/init.d/00stop_ric
fi

if [ ! -e /system/etc/init.d/00stop_ric ]; then
        echo "Creating RIC script"
        echo "#!/system/bin/sh" > /system/etc/init.d/00stop_ric
        echo "" >> /system/etc/init.d/00stop_ric
        echo "insmod /system/lib/modules/wp_mod.ko" >> /system/etc/init.d/00stop_ric
		echo "busybox sysctl -w vm.swappiness=60" >> /system/etc/init.d/00stop_ric
		echo "busybox sysctl -w vm.laptop_mode=1" >> /system/etc/init.d/00stop_ric
		echo "busybox sysctl -w vm.drop_caches=1" >> /system/etc/init.d/00stop_ric
		echo "settings put global captive_portal_detection_enabled 0" >> /system/etc/init.d/00stop_ric
		echo "busybox fstrim -v /system" >> /system/etc/init.d/00stop_ric
		echo "busybox fstrim -v /data" >> /system/etc/init.d/00stop_ric
		echo "busybox fstrim -v /cache" >> /system/etc/init.d/00stop_ric
		
        chown root.root /system/etc/init.d/00stop_ric
        chmod 0755 /system/etc/init.d/00stop_ric
fi

echo "Done!"