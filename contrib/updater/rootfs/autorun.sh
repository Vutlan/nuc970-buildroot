#!/bin/sh

echo "******************************************"
echo "* System Update (script ver.2.7)"
echo "******************************************"

./led_error.sh 10000 &

# safe_copy /src.txt /var/dst.txt 544
safe_copy() {
    local file_src
    local file_tmp
    local file_dst
    local mode

    file_src="$1"
    file_dst="$2"
    file_tmp="$2_tmp"
    mode="$3"

    if [ -e $file_src ] ; then

        echo "  copy file: $file_dst"

        rm -f "$file_tmp"
        cp "$file_src" "$file_tmp"
        chmod "$mode" "$file_tmp"
        mv -f "$file_tmp" "$file_dst"
    else
        echo "  file not found: $file_src"
    fi
}


# print content
echo $PWD
ls -l .

echo "clean up directories: /opt/xmon/"

rm -fR /opt/xmon/bin/

# replace xmoncheck.sh script, it is need for work
safe_copy wd/xmoncheck.sh.0 /opt/xmon/bin/xmoncheck.sh 775

#rm -fR ${XMON_PATH}/firmware/
rm -fR /opt/xmon/etc/services/
rm -fR /opt/xmon/lib/
rm -fR /opt/xmon/www/
rm -fR /opt/xmon/recovery/
#rm -fR /etc/init.d/

echo "remove RADIUS dictionary.local"
rm -f /opt/xmon/etc/radius/dictionary.local

echo "copy new directories: /opt/xmon/"
cp -af opt/ /

#echo "copy new directories: /etc/init.d/"
#cp -af etc/init.d/ /etc/

# copy files one by one, place it here
echo "copy new files:"
#safe_copy etc/init.d/S59snmpd /etc/init.d/S59snmpd 755
#safe_copy bin/busybox /bin/busybox 755
safe_copy usr/bin/mjpg_streamer /usr/bin/mjpg_streamer 755
safe_copy usr/lib/mjpg-streamer/input_uvc.so /usr/lib/mjpg-streamer/input_uvc.so 755

rm -f /opt/xmon/bin/xmoncheck.sh
#cp wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh
safe_copy wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh 775

sleep 2
killall led_error.sh
./led_ok.sh

echo "Reboot ..."
reboot

exit 0


