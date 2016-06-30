XMON_VERSION = master
XMON_SITE = git@github.com:Vutlan/XMON.git
XMON_SITE_METHOD = git

#local building
#XMON_OVERRIDE_SRCDIR = /home/serega/MyWork/nuc970/contrib/work/xmon
#XMON_OVERRIDE_RSYNC = yes

XMOD_INSTALL_STAGING = YES
XMOD_INSTALL_TARGET = YES
#XMOD_CONF_OPTS = -DBUILD_DEMOS=ON
#XMOD_DEPENDENCIES = libglib2 host-pkgconf

#define XMON_INSTALL_STAGING_CMDS
#        echo "Install staging"
#        $(MAKE) install
#endef

#define XMON_INSTALL_TARGET_CMDS
#        echo "Install target" 
#        make -f $(@D)/Makefile help
#        make -f $(@D)/Makefile install
#endef

define XMON_INSTALL_TARGET_CMDS
        if ! [ -d "$(TARGET_DIR)/opt/xmon/" ]; then \
                mkdir -p $(TARGET_DIR)/opt/xmon; \
        fi
        cp -R $(@D)/bin/ $(@D)/etc/ $(@D)/lib/ $(@D)/recovery/ $(@D)/www/ $(TARGET_DIR)/opt/xmon/
endef

$(eval $(cmake-package))

