#!/bin/bash

echo "*************************************************"
echo "* Script for prebuild (script ver.1.0)"
echo "*   target: ${TARGET_DIR}"
echo "*************************************************"

#KERNEL_VERSION_STAMP="01.02.2019"
#KERNEL_VERSION_STAMP="12.03.2019"
#KERNEL_VERSION_STAMP="30.04.2019"
#KERNEL_VERSION_STAMP="20.05.2019"
KERNEL_VERSION_STAMP="17.06.2019"

# push kernel version stamp
echo "    Vutlan kernel version stamp: ${KERNEL_VERSION_STAMP}"
echo "VUTLAN_KERNEL_VERSION=${KERNEL_VERSION_STAMP}" >> ${TARGET_DIR}/etc/os-release

# delete unused files
rm -f ${TARGET_DIR}/etc/init.d/S50dropbear
rm -f ${TARGET_DIR}/etc/init.d/S60openvpn
rm -f ${TARGET_DIR}/etc/init.d/S50smsd
rm -f ${TARGET_DIR}/etc/smsd.conf
rm -f ${TARGET_DIR}/etc/nginx/*.default 

# create links
ln -sf ../opt/xmon/etc/localtime ${TARGET_DIR}/etc/localtime


