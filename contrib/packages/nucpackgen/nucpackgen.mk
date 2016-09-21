#git
NUCPACKGEN_VERSION = master
NUCPACKGEN_SITE = git@github.com:Vutlan/NucPackGen.git
NUCPACKGEN_SITE_METHOD = git

#local building
#NUCPACKGEN_OVERRIDE_SRCDIR = /home/serega/MyWork/nuc970/contrib/utils/nucpackgen
#NUCPACKGEN_OVERRIDE_RSYNC = yes

NUCPACKGEN_INSTALL_STAGING = YES
NUCPACKGEN_INSTALL_TARGET = YES

NUCPACKGEN_CONF_OPTS =

$(eval $(host-cmake-package))

