#!/bin/bash -e

#
# Build firmware scripts
#

BRANDS=("VUTLAN" "DIDACTUM" "BKT" "SCHAFER" "LANDE")
BRANDS_EXT=("vut" "zor" "bkt" "sit" "lne")
BR_FILE_CONFIG="./output/.config.old"
XMON_DIR="./output/build/xmon-master"
OUTPUT_DIR="./output/firmware"
README_FILE="${OUTPUT_DIR}/readme.txt"

# see linux kernel scripts/config
set_var() {
	local name=$1 new=$2 before=$3

	name_re="^($name=|# $name is not set)"
	before_re="^($before=|# $before is not set)"
	if test -n "$before" && grep -Eq "$before_re" "$BR_FILE_CONFIG"; then
		sed -ri "/$before_re/a $new" "$BR_FILE_CONFIG"
	elif grep -Eq "$name_re" "$BR_FILE_CONFIG"; then
		sed -ri "s:$name_re.*:$new:" "$BR_FILE_CONFIG"
	else
		echo "$new" >>"$BR_FILE_CONFIG"
	fi
}

disable_all() {
  for brand_ in ${BRANDS[*]} 
  do
    set_var "BR2_PACKAGE_XMON_${brand_}" "# BR2_PACKAGE_XMON_${brand_} is not set"
  done
}

get_version() {
  VERSION=`cat ${XMON_DIR}/VERSION`
# find string '   set(XMON_VERSION_BUILD "325") in CMakeLists.txt'
  BUILD=`grep "set(XMON_VERSION_BUILD \"[0-9]*\")" ${XMON_DIR}/CMakeLists.txt | grep -o '[0-9]*'`
  #echo ${VERSION}-b${BUILD}
}

# clean rootfs
rm -fR output/target/opt/xmon

# remove source
./build.sh xmon-dirclean
#rm buildroot/dl/xmon-master.tar.gz

#
# does recreate the output dirs
#
if [ -d ${OUTPUT_DIR} ]; then
  rm -fR ${OUTPUT_DIR}
fi

mkdir -pv ${OUTPUT_DIR}

echo -e "Firmwares for NUC976 based master modules:\n" > ${README_FILE}

#
# does rebuild firmwares for all brands
#
for index in ${!BRANDS[*]}
do
  disable_all
  set_var "BR2_PACKAGE_XMON_${BRANDS[$index]}" "BR2_PACKAGE_XMON_${BRANDS[$index]}=y"
  
  #cat ${BR_FILE_CONFIG}
  # reload and build
  ./build.sh xmon-reconfigure

  # rebuild firmware
  ./build.sh
  
  #echo "* ${BRANDS[$index],,} ${BRANDS_EXT[$index]}"
  get_version
  #echo "${BRANDS[$index],,}-${VERSION}-b${BUILD}.bin"
  cp output/images/nucwriterpack.bin "${OUTPUT_DIR}/${BRANDS[$index],,}-${VERSION}-b${BUILD}.bin"
  #echo "firmware-${VERSION}-b${BUILD}.${BRANDS_EXT[$index]}"
  cp output/images/firmware.vut "${OUTPUT_DIR}/${BRANDS[$index],,}-${VERSION}-b${BUILD}.${BRANDS_EXT[$index]}"
  
  echo -e "* ${BRANDS[$index],,}-${VERSION}-b${BUILD}.bin - factory firmware for ${BRANDS[$index]}" >> ${README_FILE}
  echo -e "* ${BRANDS[$index],,}-${VERSION}-b${BUILD}.${BRANDS_EXT[$index]} - firmware update for ${BRANDS[$index]}" >> ${README_FILE}
  
  echo "Firmare ${BRANDS[$index],,}-${VERSION}-b${BUILD}.bin, ${BRANDS[$index],,}-${VERSION}-b${BUILD}.${BRANDS_EXT[$index]} complete"
    
  sleep 1
done

echo -e "\n"`date '+%d.%m.%Y'` >> ${README_FILE}
sync

# does build zip-archive
cd ${OUTPUT_DIR}
zip -9 -r ../../../firmware-${VERSION}-b${BUILD}.zip ./*
cd -;


