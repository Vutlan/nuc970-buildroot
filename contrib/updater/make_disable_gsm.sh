#!/bin/bash

echo "*************************************************"
echo "* Script for disable gsmmodemd (script ver.0.9)"
echo "*   tools: ${BR2_EXTERNAL}/updater"
echo "*   rootfs: ${TARGET_DIR}"
echo "*   output: ${BASE_DIR}"
echo "*************************************************"

FILENAME=disable_gsmmodemd
FILEEXT=vut

#rm -fR ${BASE_DIR}/updater

#rsync -avzh ${BR2_EXTERNAL}/updater ${BASE_DIR} > /dev/null 2>&1

# dirs for xmon
#mkdir -p ${BASE_DIR}/updater/rootfs_dis/opt/xmon
#mkdir -p ${BASE_DIR}/updater/rootfs_dis/opt/xmon/etc

# copy sources to target update for xmon
#rsync -avzh ${TARGET_DIR}/opt/xmon/etc/services ${BASE_DIR}/updater/rootfs_dis/opt/xmon/etc > /dev/null 2>&1
#rm -f ${BASE_DIR}/updater/rootfs_dis/opt/xmon/etc/services/S25gsmmodemd

pushd ${BASE_DIR}/updater/ > /dev/null 2>&1

./makeself.sh --notemp --nox11 ./rootfs_dis/ ${FILENAME}.sh "Disabling gsmmodemd" ./autorun.sh > /dev/null 2>&1
openssl enc -aes-256-cbc -salt -in ${FILENAME}.sh -out ${BASE_DIR}/images/${FILENAME}.${FILEEXT} -pass file:./key20001.txt > /dev/null 2>&1

rm -f ${FILENAME}.sh

popd > /dev/null 2>&1


