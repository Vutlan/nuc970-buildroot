#!/bin/bash

BUILDROOT_PATH=${PWD}/buildroot
OUTPUT_PATH=${PWD}/output
CONTRIB_PATH=${PWD}/contrib
DEFCONFIG_FILE=${CONTRIB_PATH}/configs/vt300_defconfig

# buildroot savedefconfig
make -C ${BUILDROOT_PATH} O=${OUTPUT_PATH} BR2_DEFCONFIG=${DEFCONFIG_FILE} savedefconfig

# how update linux defconfig
./build.sh linux-update-defconfig
