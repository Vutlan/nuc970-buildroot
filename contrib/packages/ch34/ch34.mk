CH34_MODULE_VERSION = 1.0
#CH34_SITE = /home/gernerterner/repo/nuc970-buildroot-master/nuc970-buildroot/contrib/packages/ch34/src
#CH34_SITE_METHOD = local

CH34_OVERRIDE_SRCDIR = /home/gernerterner/repo/nuc970-buildroot-master/nuc970-buildroot/contrib/packages/ch34/src
CH34_OVERRIDE_RSYNC = yes

#CH34_LICENSE = GPLv2
#CH34_LICENSE_FILES = COPYING
#CH34_MODULE_MAKE_OPTS = \
#        CONFIG_DUMMY1= \
#        CONFIG_DUMMY2=y

define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
#        $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
#        $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef

$(eval $(kernel-module))
$(eval $(generic-package))
