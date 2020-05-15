################################################################################
#
# libowfs
#
################################################################################

LIBOWFS_VERSION = 3.1p4
LIBOWFS_SOURCE = owfs-$(LIBOWFS_VERSION).tar.gz
LIBOWFS_SITE = http://downloads.sourceforge.net/project/owfs/owfs/$(LIBOWFS_VERSION)

#LIBOWFS_VERSION = master
#v3.1p4
#LIBOWFS_SITE = https://github.com/owfs/owfs.git
#LIBOWFS_SITE_METHOD = git


LIBOWFS_DEPENDENCIES = host-pkgconf



LIBOWFS_CONF_OPTS = --prefix=/usr \
  --disable-debian \
  --disable-owshell \
  --disable-owhttpd \
  --disable-owftpd \
  --disable-owserver \
  --disable-owexternal \
  --disable-ownet \
  --disable-ownetlib \
  --disable-owtap \
  --disable-owmon \
  --disable-i2c \
  --disable-zero \
  --disable-usb \
  --disable-avahi \
  --disable-parport \
  --disable-ftdi \
  --disable-owperl \
  --disable-owphp \
  --disable-owpython \
  --disable-owtcl
  
LIBOWFS_AUTORECONF = YES

LIBOWFS_LICENSE = GPLv2+, LGPLv2 (owtcl)
LIBOWFS_LICENSE_FILES = COPYING COPYING.LIB
LIBOWFS_INSTALL_STAGING = YES


$(eval $(autotools-package))
