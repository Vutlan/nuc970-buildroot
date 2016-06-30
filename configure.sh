#!/bin/bash

BUILDROOT_PATH=${PWD}/buildroot
OUTPUT_PATH=${PWD}/output
CONTRIB_PATH=${PWD}/contrib
DEFCONFIG_FILE=${CONTRIB_PATH}/configs/vt300_defconfig

# uncomment bellow :

# 1) defconfig
make BR2_EXTERNAL=${CONTRIB_PATH} -C ${BUILDROOT_PATH} O=${OUTPUT_PATH} BR2_DEFCONFIG=${DEFCONFIG_FILE} defconfig

# 2) savedefconfig
#make -C ${BUILDROOT_PATH} O=${OUTPUT_PATH} BR2_DEFCONFIG=${DEFCONFIG_FILE} savedefconfig

