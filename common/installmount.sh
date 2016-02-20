#!/sbin/sh

if [ ! -d /system/etc/init.d ]; then
        echo "Create init.d folder" 
	mkdir /system/etc/init.d
        chown root.root /system/etc/init.d
        chmod 0755 /system/etc/init.d
fi

if [ -e /system/etc/init.qcom.post_boot.sh ]; then
	if grep "/system/xbin/busybox run-parts /system/etc/init.d" /system/etc/init.qcom.post_boot.sh > /dev/null; then
		:
	else
		echo "/system/xbin/busybox run-parts /system/etc/init.d" >> /system/etc/init.qcom.post_boot.sh
	fi
elif [ -e /system/etc/hw_config.sh ]; then
	if grep "/system/xbin/busybox run-parts /system/etc/init.d" /system/etc/hw_config.sh > /dev/null; then
		:
	else
		echo "/system/xbin/busybox run-parts /system/etc/init.d" >> /system/etc/hw_config.sh
	fi
fi

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

if [ ! -x /system/xbin/busybox ]; then
   echo "copy busybox to system"
   cp /tmp/busybox /system/xbin/busybox
   chown root.shell /system/xbin/busybox
   chmod 0755 /system/xbin/busybox
   /system/xbin/busybox --install -s /system/xbin
fi
echo "Setting-up of init.d and RIC script finished"