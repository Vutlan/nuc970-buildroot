#!/bin/bash

echo "*************************************************"
echo "* Script for make kernel update (script ver.1.0)"
echo "*   tools: ${BR2_EXTERNAL}/updater"
echo "*   rootfs: ${TARGET_DIR}"
echo "*   output: ${BASE_DIR}"
echo "*************************************************"

FILENAME=firmware-kernel
FILEEXT=vut
KERNEL_DIR=${BASE_DIR}/updater/kernel

echo "*** Build kernel update"

rm -fR ${BASE_DIR}/updater
rsync -avzh ${BR2_EXTERNAL}/updater ${BASE_DIR} > /dev/null 2>&1

# copy kernel image
mkdir -p ${KERNEL_DIR}/boot
cp -f ${BASE_DIR}/images/uImage ${KERNEL_DIR}/boot/

# copy kernel modules
mkdir -p ${KERNEL_DIR}/rootfs/lib/modules
rsync -avzh ${TARGET_DIR}/lib/modules ${KERNEL_DIR}/rootfs/lib > /dev/null 2>&1

# copy rootfs files
mkdir -p ${KERNEL_DIR}/rootfs/etc/init.d
rsync -avzh ${TARGET_DIR}/etc/init.d ${KERNEL_DIR}/rootfs/etc > /dev/null 2>&1
cp -f ${TARGET_DIR}/etc/os-release ${KERNEL_DIR}/rootfs/etc/os-release
cp -f ${TARGET_DIR}/etc/shadow ${KERNEL_DIR}/rootfs/etc/shadow

# busybox bin
mkdir -p ${KERNEL_DIR}/rootfs/bin
rsync -avzh ${TARGET_DIR}/bin ${KERNEL_DIR}/rootfs > /dev/null 2>&1

# only busybox links ?
#mkdir -p ${KERNEL_DIR}/rootfs/sbin
#rsync -avzh ${TARGET_DIR}/sbin ${KERNEL_DIR}/rootfs > /dev/null 2>&1

# много лишнего - индивидуальное копирование
mkdir -p ${KERNEL_DIR}/rootfs/usr/bin
#rsync -avzh ${TARGET_DIR}/usr/bin ${KERNEL_DIR}/rootfs/usr > /dev/null 2>&1
cp -f ${TARGET_DIR}/usr/bin/agentxtrap ${KERNEL_DIR}/rootfs/usr/bin/agentxtrap
cp -f ${TARGET_DIR}/usr/bin/poff ${KERNEL_DIR}/rootfs/usr/bin/poff
cp -f ${TARGET_DIR}/usr/bin/pon ${KERNEL_DIR}/rootfs/usr/bin/pon
cp -f ${TARGET_DIR}/usr/bin/sendsms ${KERNEL_DIR}/rootfs/usr/bin/sendsms
cp -f ${TARGET_DIR}/usr/bin/smsd ${KERNEL_DIR}/rootfs/usr/bin/smsd

#mkdir -p ${KERNEL_DIR}/rootfs/usr/lib/pppd
mkdir -p ${KERNEL_DIR}/rootfs/usr/lib
rsync -avzh ${TARGET_DIR}/usr/lib/pppd ${KERNEL_DIR}/rootfs/usr/lib > /dev/null 2>&1
cp -f ${TARGET_DIR}/usr/lib/libnetsnmpmibs.so.30.0.3 ${KERNEL_DIR}/rootfs/usr/lib/libnetsnmpmibs.so.30.0.3
cp -f ${TARGET_DIR}/usr/lib/libpcap.so.1.7.4 ${KERNEL_DIR}/rootfs/usr/lib/libpcap.so.1.7.4
cp -f ${TARGET_DIR}/usr/lib/libzlog.so.1.2 ${KERNEL_DIR}/rootfs/usr/lib/libzlog.so.1.2

mkdir -p ${KERNEL_DIR}/rootfs/usr/sbin
cp -f ${TARGET_DIR}/usr/sbin/chat ${KERNEL_DIR}/rootfs/usr/sbin/chat
#cp -f ${TARGET_DIR}/usr/sbin/nginx ${KERNEL_DIR}/rootfs/usr/sbin/nginx
cp -f ${TARGET_DIR}/usr/sbin/openvpn ${KERNEL_DIR}/rootfs/usr/sbin/openvpn
cp -f ${TARGET_DIR}/usr/sbin/pppd ${KERNEL_DIR}/rootfs/usr/sbin/pppd
cp -f ${TARGET_DIR}/usr/sbin/pppdump ${KERNEL_DIR}/rootfs/usr/sbin/pppdump
cp -f ${TARGET_DIR}/usr/sbin/pppoe-discovery ${KERNEL_DIR}/rootfs/usr/sbin/pppoe-discovery
cp -f ${TARGET_DIR}/usr/sbin/pppstats ${KERNEL_DIR}/rootfs/usr/sbin/pppstats

# dhcp scripts
mkdir -p ${KERNEL_DIR}/rootfs/usr/share/udhcpc
rsync -avzh ${TARGET_DIR}/usr/share/udhcpc ${KERNEL_DIR}/rootfs/usr/share > /dev/null 2>&1

# push kernel version stamp
echo "    Vutlan kernel version stamp: 01.02.2019"
echo "VUTLAN_KERNEL_VERSION=01.02.2019" >> ${KERNEL_DIR}/rootfs/etc/os-release

pushd ${BASE_DIR}/updater/ > /dev/null 2>&1

./makeself.sh --notemp --nox11 ./kernel/ ${FILENAME}.sh "Kernel firmware updating" ./autorun.sh > /dev/null 2>&1
openssl enc -aes-256-cbc -salt -in ${FILENAME}.sh -out ${BASE_DIR}/images/${FILENAME}.${FILEEXT} -pass file:./key20001.txt > /dev/null 2>&1

rm -f ${FILENAME}.sh

popd > /dev/null 2>&1

echo "*** Build kernel update is complete"
