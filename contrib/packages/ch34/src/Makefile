ifeq ($(KERNELRELEASE), )
KERNELDIR := /lib/modules/$(shell uname -r)/build
PWD :=$(shell pwd)
default:
	$(MAKE) -C $(KERNELDIR)  M=$(PWD)  
clean:
	rm -rf .tmp_versions Module.symvers *.mod.c *.o *.ko .*.cmd Module.markers modules.order
load:
	modprobe usbserial
	insmod ch34x.ko
unload:
	rmmod ch34x
else
	obj-m := ch34x.o
endif




#obj-m += $(addsuffix .o, $(notdir $(basename $(wildcard $(BR2_EXTERNAL_KERNEL_MODULE_PATH)/*.c))))
#ccflags-y := -DDEBUG -g -std=gnu99 -Wno-declaration-after-statement
#
#.PHONY: all clean
#
#all:
#    $(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' modules
#
#clean:
#    $(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' clean
