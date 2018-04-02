#!/bin/bash

echo "***************************************"
echo "* Script for make update"
echo "*   tools: ${BR2_EXTERNAL}/updater"
echo "*   rootfs: ${TARGET_DIR}"
echo "*   output: ${BASE_DIR}"
echo "***************************************"

FILENAME=firmware
FILEEXT=vut

rm -fR ${BASE_DIR}/updater

rsync -avzh ${BR2_EXTERNAL}/updater ${BASE_DIR} > /dev/null 2>&1

# update for rootfs
mkdir -p ${BASE_DIR}/updater/rootfs/opt/xmon
mkdir -p ${BASE_DIR}/updater/rootfs/etc

rsync -avzh ${TARGET_DIR}/opt/xmon/bin ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/opt/xmon/lib ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/opt/xmon/www ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/opt/xmon/recovery ${BASE_DIR}/updater/rootfs/opt/xmon > /dev/null 2>&1
rsync -avzh ${TARGET_DIR}/etc/init.d ${BASE_DIR}/updater/rootfs/etc > /dev/null 2>&1

pushd ${BASE_DIR}/updater/ > /dev/null 2>&1

./makeself.sh --notemp --nox11 ./rootfs/ ${FILENAME}.sh "Firmware updating" ./autorun.sh > /dev/null 2>&1
openssl enc -aes-256-cbc -salt -in ${FILENAME}.sh -out ${BASE_DIR}/images/${FILENAME}.${FILEEXT} -pass file:./key20001.txt > /dev/null 2>&1
# tidy
rm -f ${FILENAME}.sh

popd > /dev/null 2>&1


