################################################################################
#
# mjpg-streamer
#
################################################################################


#local building
MJPEG_STREAMER_OVERRIDE_SRCDIR = /home/gernerterner/repo/nuc970-buildroot-master/nuc970-buildroot/contrib/packages/mjpeg-streamer/mjpg-streamer-experimental
MJPEG_STREAMER_OVERRIDE_RSYNC = yes

MJPEG_STREAMER_DEPENDENCIES = jpeg

MJPEG_STREAMER_INSTALL_STAGING = YES
MJPEG_STREAMER_INSTALL_TARGET = YES

$(eval $(cmake-package))
