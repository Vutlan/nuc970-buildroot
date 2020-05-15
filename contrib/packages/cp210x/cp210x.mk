CP210X_MODULE_VERSION = 1.0
#CP210X_SITE = /home/gernerterner/repo/nuc970-buildroot-master/nuc970-buildroot/contrib/packages/cp210x/src
#CP210X_SITE_METHOD = local

CP210X_OVERRIDE_SRCDIR = /home/gernerterner/repo/nuc970-buildroot-master/nuc970-buildroot/contrib/packages/cp210x/src
CP210X_OVERRIDE_RSYNC = yes

#CP210X_LICENSE = GPLv2
#CP210X_LICENSE_FILES = COPYING
#CP210X_MODULE_MAKE_OPTS = \
#        CONFIG_DUMMY1= \
#        CONFIG_DUMMY2=y

define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
#        $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
#        $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef

$(eval $(kernel-module))
$(eval $(generic-package))
