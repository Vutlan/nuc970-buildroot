#!/bin/sh

echo "Update..."
./led_error.sh 10000 &

echo $PWD
ls -l .

echo "remove old directories"
rm -fR /opt/xmon/bin/

#replace xmoncheck.sh script, it is need for work
cp wd/xmoncheck.sh.0 /opt/xmon/bin/xmoncheck.sh

#rm -fR ${XMON_PATH}/firmware/
rm -fR /opt/xmon/lib/
rm -fR /opt/xmon/www/
rm -fR /opt/xmon/recovery/
#rm -fR /etc/init.d/

echo "copy new directories"
#copy directories from opt/... to root /...
cp -af opt/ /

echo "kill all"
killall led_error.sh

#copy files one by one, place it here
echo "copy new files"
rm -f /etc/init.d/S59snmpd
cp etc/init.d/S59snmpd /etc/init.d/S59snmpd
chmod 755 /etc/init.d/S59snmpd
#or copy full directory
#cp -af etc/ /

./led_ok.sh

echo "replace xmoncheck.sh"
rm -f /opt/xmon/bin/xmoncheck.sh
cp wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh

echo "reboot"
reboot

exit 0


