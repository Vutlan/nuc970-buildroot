#!/bin/sh

DELAY=50000
CNT=10
OLD=`cat /sys/class/leds/led_act/brightness`

clean_up() {
	echo $OLD > /sys/class/leds/led_act/brightness
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM

if [ $# -eq 1 ] ; then
    CNT=$1
fi

while [ $CNT -ne 0 ]
do 
	if [ `cat /sys/class/leds/led_act/brightness` = '1' ] ; then
		echo 0 > /sys/class/leds/led_act/brightness
	else
		echo 1 > /sys/class/leds/led_act/brightness
	fi
	
	usleep $DELAY
	
	CNT=$(($CNT-1)) 
done

echo $OLD > /sys/class/leds/led_act/brightness



