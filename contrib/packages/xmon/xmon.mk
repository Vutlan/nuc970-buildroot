#git
XMON_VERSION = master
XMON_SITE = git@github.com:Vutlan/XMON.git
#XMON_SITE = https://github.com/Vutlan/XMON.git
XMON_SITE_METHOD = git

#local building
#XMON_OVERRIDE_SRCDIR = /home/serega/MyWork/nuc970/contrib/work/xmon
#XMON_OVERRIDE_RSYNC = yes

XMON_INSTALL_STAGING = YES
XMON_INSTALL_TARGET = YES

XMON_CONF_OPTS = -DCMAKE_BUILD_TYPE=Release
#XMON_DEPENDENCIES = libglib2 host-pkgconf

ifeq ($(BR2_PACKAGE_XMON_VUTLAN),y)
  XMON_CONF_OPTS += -DXMON_BRANDNAME="vutlan"
endif

ifeq ($(BR2_PACKAGE_XMON_DIDACTUM),y)
  XMON_CONF_OPTS += -DXMON_BRANDNAME="didactum"
endif

ifeq ($(BR2_PACKAGE_XMON_BKT),y)
  XMON_CONF_OPTS += -DXMON_BRANDNAME="bkt"
endif

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

