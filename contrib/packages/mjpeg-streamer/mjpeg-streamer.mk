################################################################################
#
# mjpg-streamer
#
################################################################################

#local building
MJPEG_STREAMER_OVERRIDE_SRCDIR = /home/serega/MyWork/nuc970/contrib/mjpg-streamer/mjpg-streamer-experimental
MJPEG_STREAMER_OVERRIDE_RSYNC = yes

MJPEG_STREAMER_DEPENDENCIES = jpeg

MJPEG_STREAMER_INSTALL_STAGING = YES
MJPEG_STREAMER_INSTALL_TARGET = YES

$(eval $(cmake-package))
