#!/bin/sh

export PATH=$PATH:/mnt/jffs/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/jffs/lib

SERVICE="canbusd"
ETC_PATH="/mnt/jffs/etc"
FILENO="/tmp/no${SERVICE}"
CANCFGCMD=/mnt/jffs/bin/canopen
CANCONVCMD=/mnt/jffs/bin/canconv
CAN0CFGFILE=/mnt/jffs/etc/can0cfg.xml
CAN1CFGFILE=/mnt/jffs/etc/can1cfg.xml
CONFIGURATOR="false"

#FILELOG=/dev/null
FILELOG=/dev/console
#FILELOG=/var/log/canfwupdate.log

# !!! In Pcode order !!!
firmwares="mtv_ver00x03.bin ftc_ver00x03.bin  sth_ver00x04.bin an8_ver00x04.bin  dth_ver00x03.bin dry64_ver00x03.bin vt460_ver00x03.bin vt490_ver00x03.bin vt491_ver00x03.bin"
pcode_start=1
pcode_mask=""
#pcode_mask="7 8"

touch ${FILENO}
skyservice ${SERVICE} stop

echo "Setting up networking on can0" >> ${FILELOG} 2>&1
ip link set can0 up type can bitrate 125000 restart-ms 100  >> ${FILELOG} 2>&1
echo "Setting up networking on can1" >> ${FILELOG} 2>&1
ip link set can1 up type can bitrate 125000 restart-ms 100  >> ${FILELOG} 2>&1
sleep 1 #3

#udsclient /tmp/logerd.socket "<entry type=\"message\" message=\"Start of the CAN firmware updating\" />"  >> ${FILELOG} 2>&1

# run canupdater
for port in can0 can1
do
  cfgfile="${ETC_PATH}/${port}cfg.xml"
  
  echo "port ${port}:" >> ${FILELOG} 
    
  if [ -r ${cfgfile} ] ; then
	  let pcode=$pcode_start
    
    for firmware in $firmwares
    do
      
      if [ -z "${pcode_mask##*$pcode*}" ] ;then
        v=${firmware#*_ver}
	      v=${v%%.bin}
	      #ver="${v%x*}.${v#*x}"
	      ver="${v%x*}${v#*x}"
	      let rev=$ver

        echo " pcode ${pcode} will be updated to rev=${rev} by ${firmware}" >> ${FILELOG} 
        
        output=`./canupdater -b ./bin/"${firmware}" -c ${cfgfile} -i ? -p ${pcode} -r ${rev} -V 0 $port 2>&1` && {
          if [ "X${output}" != "X" ] ; then
            echo "ok: '${output}'" >> ${FILELOG}
            udsclient /tmp/logerd.socket "<entry type=\"message\" message=\"${output}\" />"  >> ${FILELOG} 2>&1
          fi
        } || {
          if [ "X${output}" != "X" ] ; then
            echo "error: '${output}'" >> ${FILELOG}
            udsclient /tmp/logerd.socket "<entry type=\"error\" message=\"${output}\" />"  >> ${FILELOG} 2>&1
          fi
        }
      else
        echo "pcode ${pcode} masked for updating" >> ${FILELOG}
      fi
      
      #next pcode
      let pcode=$pcode+1
    done
    
  else
    echo "${cfgfile} is absent or iface was not configurated" >> ${FILELOG}
    udsclient /tmp/logerd.socket "<entry type=\"message\" message=\"${port} is absent or iface was not configurated\" />" >/dev/null 2>&1
  fi
  
done

# configuration
if [ $CONFIGURATOR = "true" ] ; then
  echo "configuration..." >> ${FILELOG}
  ${CANCFGCMD} can0 -N -e -C ${CAN0CFGFILE} &
  pids="$!"
      
  ${CANCFGCMD} can1 -N -e -C ${CAN1CFGFILE} &
  pids="${pids} $!"

  if [ -n "${pids}" ]; then
    echo "wait pids: ${pids}" >> ${FILELOG}    
    wait $pids 
  fi
else
  echo "manual configuration required" >> ${FILELOG}
fi

echo "Setting down networking on can0 : " >> ${FILELOG}
ip link set can0 down >> ${FILELOG} 2>&1
echo "Setting down networking on can1 : " >> ${FILELOG}
ip link set can1 down >> ${FILELOG} 2>&1

#udsclient /tmp/logerd.socket "<entry type=\"message\" message=\"End of the CAN modules firmware updating\" />"  >> ${FILELOG} 2>&1

skyservice ${SERVICE} start
rm -r ${FILENO}

# 2.6.x need restart
reboot


