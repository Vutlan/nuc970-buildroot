NTPCLIENT_VERSION=2015_365
NTPCLIENT_SOURCE=ntpclient_$(NTPCLIENT_VERSION).tar.gz
NTPCLIENT_SITE=http://doolittle.icarus.com/ntpclient

define NTPCLIENT_BUILD_CMDS
    $(MAKE) ntpclient adjtimex -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define NTPCLIENT_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/adjtimex $(TARGET_DIR)/sbin
    $(INSTALL) -D -m 0755 $(@D)/ntpclient $(TARGET_DIR)/bin
endef

define NTPCLIENT_CLEAN_CMDS
    $(MAKE) -C $(@D) clean
endef

define NTPCLIENT_UNINSTALL_TARGET_CMDS
    rm -f $(TARGET_DIR)/sbin/adjtimex
    rm -f $(TARGET_DIR)/bin/ntpclient
endef

$(eval $(generic-package))
