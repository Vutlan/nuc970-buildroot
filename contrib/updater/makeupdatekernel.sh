#!/bin/sh

FIRMWARE_DIR_ROOT="../"
FIRMWARE_DIR_LIST="bin etc lib www firmware recovery"

FILENAME=firmware-kernel
FILEEXT=vut
KERNEL_DIR=./kernel/

OUTPUT_DIR=../_output

BUILD=`cat ${FIRMWARE_DIR_ROOT}/build-number.txt`
let BUILD=$BUILD-1 
VERSION=`cat ${FIRMWARE_DIR_ROOT}/VERSION`"-b"${BUILD}

echo "*** Build kernel update '${FILENAME}.${FILEEXT}' for ver.${VERSION}"


# make firmware updating file
echo "  make firmware updating file"	
./makeself.sh --notemp --nox11 ${KERNEL_DIR} ${FILENAME}.sh "Kernel firmware updating" ./autorun.sh > /dev/null 2>&1
openssl enc -aes-256-cbc -salt -in ${FILENAME}.sh -out ${FILENAME}.${FILEEXT} -pass file:./key20001.txt > /dev/null 2>&1
# tidy
rm -f ${FILENAME}.sh

KERNELNAME="${FILENAME}.${FILEEXT}"
MD5KERNELNAME="${FILENAME}.md5"

echo "  MD5 calculating"
md5sum -b ${KERNELNAME} > ${MD5KERNELNAME}

#copy update to output dir
echo "  copy update to:  ${OUTPUT_DIR}"
mkdir -p  ${OUTPUT_DIR}
mv ${KERNELNAME} ${OUTPUT_DIR}/${KERNELNAME}
mv ${MD5KERNELNAME} ${OUTPUT_DIR}/${MD5KERNELNAME}

echo "*** Build kernel update is complete"
