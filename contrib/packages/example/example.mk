EXAMPLE_VERSION=0.1

#EXAMPLE_SITE_METHOD=local
#EXAMPLE_SITE=$(EXAMPLE_PKGDIR)
EXAMPLE_OVERRIDE_SRCDIR = $(EXAMPLE_PKGDIR)
EXAMPLE_OVERRIDE_RSYNC = yes

define EXAMPLE_BUILD_CMDS
        $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define EXAMPLE_INSTALL_TARGET_CMDS
        if ! [ -d "$(TARGET_DIR)/bin/" ]; then \
                mkdir -p $(TARGET_DIR)/bin/; \
        fi
        $(INSTALL) -D -m 0755 $(@D)/EXAMPLE $(TARGET_DIR)/opt/
endef

define EXAMPLE_CLEAN_CMDS
        $(MAKE) -C $(@D) clean
endef

define EXAMPLE_UNINSTALL_TARGET_CMDS
        rm -f $(TARGET_DIR)/opt/EXAMPLE
endef

$(eval $(generic-package))
