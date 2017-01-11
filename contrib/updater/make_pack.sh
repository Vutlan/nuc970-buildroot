#!/bin/bash

echo "***************************************"
echo "* Script for make NuWriter Pack"
echo "*   external: ${BR2_EXTERNAL}"
echo "*   hostdir: ${HOST_DIR}" 
echo "*   output: ${BASE_DIR}"
echo "***************************************"

FILENAME=nucwriterpack
FILEEXT=bin

#rsync -avzh ${BR2_EXTERNAL}/images ${BASE_DIR} > /dev/null 2>&1
cp -f ${BR2_EXTERNAL}/images/environment.img ${BASE_DIR}/images

#> /dev/null 2>&1
which nucpackgen || {
  echo "The nucpackgen is not found in \$PATH"
} && {
  nucpackgen -i ${BASE_DIR}/images -d ${HOST_DIR}/usr/share/nucpackgen/sys_cfg/NUC976DK62Y.ini -o ${BASE_DIR}/images/${FILENAME}.${FILEEXT}
}
