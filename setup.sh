#!/bin/bash

BUILDROOT_PATH=${PWD}/buildroot
OUTPUT_PATH=${PWD}/output
CONTRIB_PATH=${PWD}/contrib
DEFCONFIG_FILE=${CONTRIB_PATH}/configs/vt300_defconfig

# setup external to contrib directory and defconfig
make BR2_EXTERNAL=${CONTRIB_PATH} -C ${BUILDROOT_PATH} O=${OUTPUT_PATH} BR2_DEFCONFIG=${DEFCONFIG_FILE} defconfig

