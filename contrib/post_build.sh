#!/bin/bash

echo "Script for prebuild for target: ${TARGET_DIR}"

rm -f ${TARGET_DIR}/etc/init.d/S50dropbear
rm -f ${TARGET_DIR}/etc/init.d/S60openvpn
rm -f ${TARGET_DIR}/etc/init.d/S50smsd
rm -f ${TARGET_DIR}/etc/nginx/*.default 

ln -sf ../opt/xmon/etc/localtime ${TARGET_DIR}/etc/localtime


