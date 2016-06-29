#AUGEAS_VERSION = b92b3d41b6c495d6d19bdd30660798bfa883cfa3
#AUGEAS_SOURCE = augeas-$(LIBFOO_VERSION).tar.gz
#AUGEAS_SITE = https://github.com/hercules-team/augeas.git
#AUGEAS_SITE_METHOD = git

AUGEAS_VERSION = 1.4.0
AUGEAS_SOURCE = augeas-$(AUGEAS_VERSION).tar.gz
AUGEAS_SITE = http://download.augeas.net

AUGEAS_INSTALL_STAGING = YES
AUGEAS_INSTALL_TARGET = YES
#LIBFOO_CONF_OPTS = --disable-shared
#LIBFOO_DEPENDENCIES = libglib2 host-pkgconf

#define AUGEAS_RUN_AUTOGEN
#	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
#endef

#AUGEAS_PRE_CONFIGURE_HOOKS = AUGEAS_RUN_AUTOGEN

$(eval $(autotools-package))
