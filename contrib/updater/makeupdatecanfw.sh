#!/bin/sh

FIRMWARE_DIR_ROOT="../"

FILENAME=firmware-canfw
FILEEXT=vut
CANFW_DIR=./canfw/

OUTPUT_DIR="../_output"
BIN_DIR="../bin"
BIN_EXE="${BIN_DIR}/canupdater"

BUILD=`cat ${FIRMWARE_DIR_ROOT}/build-number.txt`
let BUILD=$BUILD-1 
VERSION=`cat ${FIRMWARE_DIR_ROOT}/VERSION`"-b"${BUILD}

echo "*** Build CAN modules firmware update '${FILENAME}.${FILEEXT}' for ver.${VERSION}"

if [ -r ${BIN_EXE} ] ; then
  cp -af ${BIN_EXE} ${CANFW_DIR}
else  
  echo "${BIN_EXE} is absent. Abort."
  exit 1
fi
  
  

# make firmware updating file
echo "  make firmware updating file"	
./makeself.sh --notemp --nox11 ${CANFW_DIR} ${FILENAME}.sh "CAN modules firmware updating" ./autorun.sh > /dev/null 2>&1
openssl enc -aes-256-cbc -salt -in ${FILENAME}.sh -out ${FILENAME}.${FILEEXT} -pass file:./key20001.txt > /dev/null 2>&1
# tidy
rm -f ${FILENAME}.sh

CANFWNAME="${FILENAME}.${FILEEXT}"
MD5CANFWNAME="${FILENAME}.md5"

echo "  MD5 calculating"
md5sum -b ${CANFWNAME} > ${MD5CANFWNAME}

#copy update to output dir
echo "  copy update to:  ${OUTPUT_DIR}"
mkdir -p  ${OUTPUT_DIR}
mv ${CANFWNAME} ${OUTPUT_DIR}/${CANFWNAME}
mv ${MD5CANFWNAME} ${OUTPUT_DIR}/${MD5CANFWNAME}

echo "*** Build kernel update is complete"
