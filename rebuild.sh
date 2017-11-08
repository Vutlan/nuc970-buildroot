#/bin/bash

# clean rootfs
rm -fR output/target/opt/xmon

# remove source
./build.sh xmon-dirclean
rm buildroot/dl/xmon-master.tar.gz

# reload and build
./build.sh xmon-reconfigure

# rebuild firmware
./build.sh

