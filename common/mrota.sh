#!/sbin/sh

BUSYBOX=/tmp/busybox
ch_con() {
  files=$(echo $* | awk '{ print substr($0, index($0,$2)) }');
  for i in /system/bin/toybox /system/toolbox /system/bin/toolbox; do
    LD_LIBRARY_PATH=/system/lib $i chcon -h u:object_r:$1:s0 $files;
    LD_LIBRARY_PATH=/system/lib $i chcon u:object_r:$1:s0 $files;
  done;
  chcon -h u:object_r:$1:s0 $files;
  chcon u:object_r:$1:s0 $files;
}

if [ ! -e /system/bin/chargemon.bin ]; then
	ch_con system_file /system/bin/chargemon
	ch_con system_file /system/bin/cwm.cpio
	ch_con system_file /system/bin/philz.cpio
	ch_con system_file /system/bin/twrp.cpio
	ch_con system_file /system/bin/recovery.sh
	ch_con system_file /system/xbin/busybox
fi
