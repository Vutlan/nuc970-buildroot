#!/bin/sh
# Watchdog script XMON ver.1.1

. /opt/xmon/bin/board.sh

# Check UDS IPC daemons script
export PATH=$PATH:/opt/xmon/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/xmon/lib

DAEMONS="elementsd logerd internald gsmmodemd devirtd camerasd sysctrld"
RES=0

LOGFILE=/dev/null
#LOGFILE=/dev/console

echo  >> ${LOGFILE}
echo `date "+%Y-%m-%d %H:%M:%S"` "XMON check IPC:" > ${LOGFILE}

service_uds_check(){
	local RES=1
	local UDSOK="Test ok"

	if start-stop-daemon -K -q -t -n $1 ; then
	# daemon running
		UDSRES=`udsclient /var/run/xmon/${1}.socket "<test />" | grep -io "${UDSOK}"`

		if [ "$UDSRES" = "$UDSOK" ] ; then
			RES=0
		else
			RES=1
		fi
	else
	    RES=1
	fi

	return ${RES}
}

service_restart(){
    local service=`ls /opt/xmon/etc/services | grep $1`
    if [ "x${service}" != "x" ] ; then
    	echo  "Service '${service}' was restarted" >> ${LOGFILE}
    	/opt/xmon/etc/services/${service} restart
    	return 0
    else
    	echo "Service '${1}' unknown" >> ${LOGFILE}
    fi

    return 1
}

for i in ${DAEMONS}; do

	FILENO="/tmp/no${i}"

	if [ -e "$FILENO" ]; then
	    echo "Service ${i}: ${FILENO} present - skip check for service '${i}'"  >> ${LOGFILE}
		continue
	else
		if ! service_uds_check ${i} ; then
		# error
			STATE0=`cat /sys/class/gpio/gpio10/value`
			if [ ${STATE0} = "0" ] ; then
				STATE="1"
			else
				STATE="0"
			fi

			if [ "$i" = "elementsd" ] ; then
				slog.sh "error" "Service '${i}' is broken. Reboot..."
				echo "Service '${i}' is broken. Reboot..." >> ${LOGFILE}
				echo $STATE > $LED_ERROR
				#echo 1 > /sys/class/leds/led_err/brightness
				exec reboot
				RES=1
			else
				slog.sh "error" "Service '${i}' is broken. The service will be restarted"
				echo "Service '${i}' is broken. The service will be restarted" >> ${LOGFILE}
				echo $STATE > $LED_ERROR
				#echo 1 > /sys/class/leds/led_err/brightness
				service_restart $i
				sleep 1
				echo $STATE0 > $LED_ERROR
				#echo 0 > /sys/class/leds/led_err/brightness
			fi
		else
		    echo "Service '${i}' is OK" >> ${LOGFILE}
		fi
	fi
done

ftpbackup.sh &

#sync && echo 3 > /proc/sys/vm/drop_caches

exit $RES

