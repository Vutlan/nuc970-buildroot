#!/bin/sh

XMON_PATH=/opt/xmon

echo "Update..."
./led_error.sh 10000 &

echo $PWD
ls -l .

#echo "update rootfs"
#echo "update etc"
#...
#echo "update lib"
#...
#echo "update usr"
#...

echo "update userfs"
# save configuration files
rm -fR ${XMON_PATH}/bin/
echo "replace xmoncheck.sh"	
cp wd/xmoncheck.sh.0 ${XMON_PATH}/bin/xmoncheck.sh
#rm -fR ${XMON_PATH}/firmware/
rm -fR ${XMON_PATH}/lib/
rm -fR ${XMON_PATH}/www/

# 
cp -af opt/ /

killall led_error.sh

./led_ok.sh

echo "replace sky25check.sh"	
rm -f /opt/xmon/bin/xmoncheck.sh
cp wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh

reboot

exit 0


