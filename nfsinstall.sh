#!/bin/bash

IMAGES_PATH=./output/images
NFS_PATH=/var/lib/tftpboot/nuc970

sudo cp -f ${IMAGES_PATH}/uImage ${NFS_PATH}

sudo rm -fR ${NFS_PATH}/rootfs/*
sudo tar xvf ${IMAGES_PATH}/rootfs.tar -C ${NFS_PATH}/rootfs
