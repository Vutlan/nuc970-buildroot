#!/bin/sh

DELAY=50000
CNT=10
LED=/sys/class/gpio/gpio11/value
OLD=`cat ${LED}`

clean_up() {
	echo $OLD > ${LED}
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM

if [ $# -eq 1 ] ; then
    CNT=$1
fi



while [ $CNT -ne 0 ]
do 
	echo 0 > ${LED}

  usleep $DELAY

	echo 1 > ${LED}
	
	usleep $DELAY
	
	CNT=$(($CNT-1)) 
done

echo $OLD > ${LED}





