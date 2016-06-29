################################################################################
#
# zic
#
################################################################################

ZIC_VERSION = 2015g
ZIC_SOURCE = tzcode$(ZIC_VERSION).tar.gz
ZIC_SITE = http://www.iana.org/time-zones/repository/releases
ZIC_STRIP_COMPONENTS = 0
ZIC_LICENSE = Public domain

define ZIC_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) zic
endef

define ZIC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/zic $(TARGET_DIR)/usr/sbin/zic
#	$(INSTALL) -D -m 644 $(@D)/tzfile.h $(TARGET_DIR)/usr/include/tzfile.h
endef

define XMON_CLEAN_CMDS
        $(MAKE) -C $(@D) clean
endef

define XMON_UNINSTALL_TARGET_CMDS
        rm -f $(TARGET_DIR)/usr/sbin/zic
endef

$(eval $(generic-package))
