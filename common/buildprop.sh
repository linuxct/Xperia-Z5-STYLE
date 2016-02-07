#!/sbin/sh

BUSYBOX=/tmp/busybox
GREP="${BUSYBOX} grep"

# Xperia M2 Dual
if [ "`${GREP} ro.product.name=D2302 /system/build.prop`" ]; 
   then
   cp /tmp/buildprop/dual/build.prop /system/
   cp /tmp/buildprop/dual/InCallUI.apk /system/priv-app/InCallUI/
   cp /tmp/buildprop/dual/TeleService.apk /system/priv-app/TeleService/
   cp /tmp/buildprop/dual/Settings.apk /system/priv-app/Settings/
else
   	# Xperia M2 HSPASS
	if [ "`${GREP} ro.product.name=D2305 /system/build.prop`" ];
	then
		cp /tmp/buildprop/hspass/build.prop /system/
		#cp /tmp/buildprop/dual/InCallUI.apk /system/priv-app/InCallUI/
        #cp /tmp/buildprop/dual/TeleService.apk /system/priv-app/TeleService/
	else
		# Xperia M2 LTE 
		cp /tmp/buildprop/lte/build.prop /system/
	fi
fi
