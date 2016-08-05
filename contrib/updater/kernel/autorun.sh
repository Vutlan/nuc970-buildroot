#!/bin/sh

LOGFILE=/dev/console
#LOGFILE=/dev/null

echo "Update kernel..." > ${LOGFILE} 
./led_error.sh 10000 &

if [ -r boot/zImage ] ; then
  echo "write kernel:" >> ${LOGFILE}
	#cat /proc/mtd 2>&1
	flash_eraseall /dev/mtd2 >> ${LOGFILE} 2>&1 
	nandwrite /dev/mtd2 boot/zImage -p >> ${LOGFILE}
fi

echo "update rootfs" >> ${LOGFILE}
echo "update lib: modules" >> ${LOGFILE}
cp -af lib/ /

killall led_error.sh

./led_ok.sh

reboot

exit 0



