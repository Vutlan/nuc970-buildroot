#!/bin/bash

# write into last 8kB...

dd if=/dev/zero ibs=1k count=56 | tr "\000" "\377" >padded.bin
mkenvimage -p 0xFF -s 8192 -o environment.bin environment.txt 
cat padded.bin environment.bin > environment.img

rm -f padded.bin environment.bin

#
# cat /proc/mtd
# and find "environment" mtdX
#
# write:
# flash_erase -j /dev/mtd1 0 0
# flashcp -v environment.img /dev/mtd1

