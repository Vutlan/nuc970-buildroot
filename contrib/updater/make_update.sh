#!/bin/bash

echo "*************************************************"
echo "* Script for make system update (script ver.2.7)"
echo "*   tools: ${BR2_EXTERNAL}/updater"
echo "*   rootfs: ${TARGET_DIR}"
echo "*   output: ${BASE_DIR}"
echo "*************************************************"

FILENAME=firmware
FILEEXT=vut

rm -fR ${BASE_DIR}/updater

rsync -avzh ${BR2_EXTERNAL}/updater ${BASE_DIR} > /dev/null 2>&1

# dirs for xmon
mkdir -p ${BASE_DIR}/updater/rootfs/opt/xmon
mkdir -p ${BASE_DIR}/updater/rootfs/opt/xmon/etc
mkdir -p ${BASE_DIR}/updater/rootfs/opt/xmon/etc/radius
mkdir -p ${BASE_DIR}/updater/rootfs/opt/xmon/etc/nginx

# dirs for system
mkdir -p ${BASE_DIR}/updater/rootfs/bin
mkdir -p ${BASE_DIR}/updater/rootfs/etc
mkdir -p ${BASE_DIR}/updater/rootfs/usr
mkdir -p ${BASE_DIR}/updater/rootfs/usr/bin
mkdir -p ${BASE_DIR}/updater/rootfs/usr/lib
mkdir -p ${BASE_DIR}/updater/rootfs/usr/lib/mjpg-streamer

# copy sources to target update for xmon
rsync -avzh ${TARGET_DIR}/opt/xmon/bin ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/opt/xmon/etc/services ${BASE_DIR}/updater/rootfs/opt/xmon/etc > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/opt/xmon/lib ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/opt/xmon/www ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/opt/xmon/recovery ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1

# RADIUS dictionary.local update file
cp -f ${TARGET_DIR}/opt/xmon/etc/radius/dictionary.local ${BASE_DIR}/updater/rootfs/opt/xmon/etc/radius/dictionary.local > /dev/null 2>&1

# update system init scripts dir
rsync -avzh ${TARGET_DIR}/etc/init.d ${BASE_DIR}/updater/rootfs/etc > /dev/null 2>&1

# busybox update file - now in kernel patch
#cp -f ${TARGET_DIR}/bin/busybox ${BASE_DIR}/updater/rootfs/bin/busybox > /dev/null 2>&1

# update nginx server config files
cp -f ${TARGET_DIR}/opt/xmon/etc/nginx/webui2 ${BASE_DIR}/updater/rootfs/opt/xmon/etc/nginx/webui2 > /dev/null 2>&1
cp -f ${TARGET_DIR}/opt/xmon/etc/nginx/webui_safemode ${BASE_DIR}/updater/rootfs/opt/xmon/etc/nginx/webui_safemode > /dev/null 2>&1

# mjpg_streamer update files
cp -f ${TARGET_DIR}/usr/bin/mjpg_streamer ${BASE_DIR}/updater/rootfs/usr/bin/mjpg_streamer > /dev/null 2>&1
cp -f ${TARGET_DIR}/usr/lib/mjpg-streamer/input_uvc.so ${BASE_DIR}/updater/rootfs/usr/lib/mjpg-streamer/input_uvc.so > /dev/null 2>&1

pushd ${BASE_DIR}/updater/ > /dev/null 2>&1

./makeself.sh --notemp --nox11 ./rootfs/ ${FILENAME}.sh "Firmware updating" ./autorun.sh > /dev/null 2>&1
openssl enc -aes-256-cbc -salt -in ${FILENAME}.sh -out ${BASE_DIR}/images/${FILENAME}.${FILEEXT} -pass file:./key20001.txt > /dev/null 2>&1

rm -f ${FILENAME}.sh

popd > /dev/null 2>&1


