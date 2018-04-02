#!/bin/sh

FIRMWARE_DIR_ROOT="../"
#FIRMWARE_DIR_LIST="bin etc lib www firmware recovery"

FILENAME=firmware
FILEEXT=vut
USERFS_DIR=./imx25/jffs/
WD_DIR=./imx25/wd/

OUTPUT_DIR=../_output

BUILD=`cat ${FIRMWARE_DIR_ROOT}/build-number.txt`
let BUILD=$BUILD-1
VERSION=`cat ${FIRMWARE_DIR_ROOT}/VERSION`"-b"${BUILD}

echo "*** Build firmware update '${FILENAME}.${FILEEXT}' for ver.${VERSION}"

#Prepare USERFS_DIR
# Clean USERFS_DIR
rm -fR ${USERFS_DIR}
mkdir -p ${USERFS_DIR}
# Make USERFS_DIR
chmod 777 ${USERFS_DIR}
# Try USERFS_DIR
if [ -z ${USERFS_DIR} ] ; then
    echo "*** Building factory is failed"
    exit 1
fi
# Copy files
echo "  copy files from '${FIRMWARE_DIR_ROOT}' to '${USERFS_DIR}'"

sudo cp -aR "../bin"/ ${USERFS_DIR}
sudo cp -aR "../etc"/ ${USERFS_DIR}
sudo cp -aR "../lib"/ ${USERFS_DIR}
sudo cp -aR "../www"/ ${USERFS_DIR}
sudo cp -aR "../recovery"/ ${USERFS_DIR}
sudo cp -aR "../firmware"/ ${USERFS_DIR}


#for DIR in $FIRMWARE_DIR_LIST; do
#  DIRPATH="${FIRMWARE_DIR_ROOT}${DIR}"
#	#echo "    copy dir ${DIRPATH}/ to "${USERFS_DIR}${DIR}
#	sudo cp -aR ${DIRPATH}/ ${USERFS_DIR}
#done



#make VERSION
echo "  make VERSION"
echo ${VERSION} > "${USERFS_DIR}/VERSION"

#remove WD check script
echo "  move WD check script: ${USERFS_DIR}bin/sky25check.sh to ${WD_DIR}"
mv ${USERFS_DIR}/bin/sky25check.sh ${WD_DIR}

#pack www
WWW_DIR='www/'
pushd ${USERFS_DIR} > /dev/null 2>&1

if [ -d $WWW_DIR ]; then
	echo "  pack '${USERFS_DIR}${WWW_DIR}'"
	sudo chown 99:99 -R $WWW_DIR
	tar cjvf www.tar.bz2 $WWW_DIR > /dev/null 2>&1
	sudo rm -fR $WWW_DIR
else
	echo "  '${WWW_DIR}' not found"
	exit 1
fi

popd > /dev/null 2>&1


# make firmware updating file
echo "  make firmware updating file"
./makeself.sh --notemp --nox11 ./imx25/ ${FILENAME}.sh "Firmware updating" ./autorun.sh > /dev/null 2>&1
openssl enc -aes-256-cbc -salt -in ${FILENAME}.sh -out ${FILENAME}.${FILEEXT} -pass file:./key20001.txt > /dev/null 2>&1
# tidy
rm -f ${FILENAME}.sh

NOVERNAME="${FILENAME}.${FILEEXT}"
MD5NOVERNAME="${FILENAME}.md5"
VERNAME="${FILENAME}-${VERSION}.${FILEEXT}"
MD5VERNAME="${FILENAME}-${VERSION}.md5"

echo "  MD5 calculating"
cp ${NOVERNAME} ${VERNAME}
md5sum -b ${NOVERNAME} > ${MD5NOVERNAME}
md5sum -b ${VERNAME} > ${MD5VERNAME}

#copy update to output dir
echo "  copy update to:  ${OUTPUT_DIR}"
mkdir -p  ${OUTPUT_DIR}
mv ${NOVERNAME} ${OUTPUT_DIR}/${NOVERNAME}
mv ${MD5NOVERNAME} ${OUTPUT_DIR}/${MD5NOVERNAME}
mv ${VERNAME} ${OUTPUT_DIR}/${VERNAME}
mv ${MD5VERNAME} ${OUTPUT_DIR}/${MD5VERNAME}

echo "*** Build firmware update was complete"
