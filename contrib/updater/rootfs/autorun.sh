#!/bin/sh

echo "******************************************"
echo "* System Update (script ver.2.3)"
echo "******************************************"

./led_error.sh 10000 &

#safe_copy /text.txt /var/text.txt 544
safe_copy() {
    local file_src
    local file_tmp
    local file_dst
    local mode

    file_src="$1"
    file_dst="$2"
    file_tmp="$2_tmp"
    mode="$3"

    echo "  copy file: $file_dst"

    rm -f "$file_tmp"
    cp "$file_src" "$file_tmp"
    chmod "$mode" "$file_tmp"
    mv -f "$file_tmp" "$file_dst"
}


echo $PWD
ls -l .

echo "clean up directories: /opt/xmon/"

rm -fR /opt/xmon/bin/

#replace xmoncheck.sh script, it is need for work
safe_copy wd/xmoncheck.sh.0 /opt/xmon/bin/xmoncheck.sh 775

#rm -fR ${XMON_PATH}/firmware/
rm -fR /opt/xmon/etc/services/
rm -fR /opt/xmon/lib/
rm -fR /opt/xmon/www/
rm -fR /opt/xmon/recovery/
#rm -fR /etc/init.d/

echo "copy new directories: /opt/xmon/"
#copy directories from opt/... to root /...
cp -af opt/ /

echo "kill all"
killall led_error.sh

#copy files one by one, place it here
echo "copy new files:"
safe_copy etc/init.d/S59snmpd /etc/init.d/S59snmpd 755
safe_copy bin/busybox /bin/busybox 755

#or copy full directory
#cp -af etc/ /

./led_ok.sh

rm -f /opt/xmon/bin/xmoncheck.sh
#cp wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh
safe_copy wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh 775

echo "reboot"
reboot

exit 0


