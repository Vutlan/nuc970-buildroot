#!/bin/sh

echo "******************************************"
echo "* Kernel Update (script ver.1.6)"
echo "******************************************"

./led_error.sh 10000 &

# safe_copy /src.txt /var/dst.txt 544
safe_copy() {
    local file_src
    local file_tmp
    local file_dst
    local mode

    file_src="$1"
    file_dst="$2"
    file_tmp="$2_tmp"
    mode="$3"

    if [ -e $file_src ] ; then

        echo "    copy file: $file_dst"

        rm -f "$file_tmp"
        cp "$file_src" "$file_tmp"
        chmod "$mode" "$file_tmp"
        mv -f "$file_tmp" "$file_dst"
    else
        echo "  file not found: $file_src"
    fi
}


# print content
echo $PWD
ls -l .

# replace xmoncheck.sh script, it is need for work
safe_copy wd/xmoncheck.sh.0 /opt/xmon/bin/xmoncheck.sh 775

echo "Update kernel..."

if [ -r boot/uImage ] ; then
    echo "  erase kernel"
    flash_erase --quiet /dev/mtd2 0 49
    echo "  write kernel"
    flashcp boot/uImage /dev/mtd2
fi

echo "  update lib modules /lib/modules/"
rm -fR /lib/modules/
cp -af rootfs/lib/modules/ /lib/

echo "Update rootfs ..."

echo "  update /etc/"
safe_copy rootfs/etc/os-release     /etc/os-release 644
safe_copy rootfs/etc/shadow         /etc/shadow 600

echo "  update /etc/init.d/"
rm -fR /etc/init.d/
cp -af rootfs/etc/init.d/ /etc/

echo "  update nginx config"
rm -fR /etc/nginx/
cp -af rootfs/etc/nginx/ /etc/
safe_copy rootfs/opt/xmon/etc/nginx/webui2     /opt/xmon/etc/nginx/webui2 644
safe_copy rootfs/opt/xmon/etc/nginx/webui_safemode     /opt/xmon/etc/nginx/webui_safemode 644

echo "  update /bin/busybox"
safe_copy rootfs/bin/busybox        /bin/busybox 755

echo "  update /usr/bin/"
safe_copy rootfs/usr/bin/agentxtrap /usr/bin/agentxtrap 755
safe_copy rootfs/usr/bin/poff       /usr/bin/poff 755
safe_copy rootfs/usr/bin/pon        /usr/bin/pon 755
safe_copy rootfs/usr/bin/sendsms    /usr/bin/sendsms 755
safe_copy rootfs/usr/bin/smsd       /usr/bin/smsd 755
safe_copy rootfs/usr/bin/sqlite3    /usr/bin/sqlite3 755

echo "  update /usr/lib/"
safe_copy rootfs/usr/lib/libnetsnmpmibs.so.30.0.3   /usr/lib/libnetsnmpmibs.so.30.0.3 755
safe_copy rootfs/usr/lib/libpcap.so.1.7.4           /usr/lib/libpcap.so.1.7.4 755
safe_copy rootfs/usr/lib/libzlog.so.1.2             /usr/lib/libzlog.so.1.2 755
ln -sf "/usr/lib/libnetsnmpmibs.so.30.0.3"          /usr/lib/libnetsnmpmibs.so.30
ln -sf "/usr/lib/libpcap.so.1.7.4"                  /usr/lib/libpcap.so.1
ln -sf "/usr/lib/libzlog.so.1.2"                    /usr/lib/libzlog.so.1
safe_copy rootfs/usr/lib/libmodbus.so.5.1.0         /usr/lib/libmodbus.so.5.1.0 755
ln -sf "/usr/lib/libmodbus.so.5.1.0"                /usr/lib/libmodbus.so.5
ln -sf "/usr/lib/libmodbus.so.5.1.0"                /usr/lib/libmodbus.so
rm -f rootfs/usr/lib/libmodbus.so.5.0.5
safe_copy rootfs/usr/lib/libsqlite3.so.0.8.6        /usr/lib/libsqlite3.so.0.8.6 755
ln -sf "/usr/lib/libsqlite3.so.0.8.6"               /usr/lib/libsqlite3.so.0
ln -sf "/usr/lib/libsqlite3.so.0.8.6"               /usr/lib/libsqlite3.so

echo "  update /usr/lib/pppd/"
rm -fR /usr/lib/pppd/
cp -af rootfs/usr/lib/pppd/ /usr/lib/

echo "  update /usr/sbin/"
safe_copy rootfs/usr/sbin/chat              /usr/sbin/chat 755
safe_copy rootfs/usr/sbin/openvpn           /usr/sbin/openvpn 755
safe_copy rootfs/usr/sbin/pppd              /usr/sbin/pppd 755
safe_copy rootfs/usr/sbin/pppdump           /usr/sbin/pppdump 755
safe_copy rootfs/usr/sbin/pppoe-discovery   /usr/sbin/pppoe-discovery 755
safe_copy rootfs/usr/sbin/pppstats          /usr/sbin/pppstats 755
safe_copy rootfs/usr/sbin/nginx             /usr/sbin/nginx 755

echo "  update /usr/share/udhcpc/"
rm -fR /usr/share/udhcpc/
cp -af rootfs/usr/share/udhcpc/ /usr/share/udhcpc/

echo "  remove useless"
rm -f /usr/bin/cache_calibrator
rm -f /usr/bin/dbclient
rm -f /usr/bin/dropbearconvert
rm -f /usr/bin/dropbearkey
rm -f /usr/bin/mbim-network
rm -f /usr/bin/mbimcli
rm -f /usr/bin/memstat
rm -f /usr/bin/netperf
rm -f /usr/bin/netserver
rm -f /usr/bin/qmi-network
rm -f /usr/bin/qmicli
rm -f /usr/bin/ramspeed
rm -f /usr/bin/scp
rm -f /usr/bin/ssh
rm -f /usr/bin/strace
rm -f /usr/bin/strace-log-merge
rm -f /usr/bin/stress
rm -f /usr/bin/tinymembench
rm -f /usr/bin/whetstone
rm -f /usr/lib/libgudev*
rm -f /usr/lib/libmbim*
rm -f /usr/lib/libqmi*
rm -f /usr/sbin/dropbear
rm -f /usr/sbin/spidev_test
rm -f /usr/share/local/*
rm -f /etc/udev/hwdb.d/*
rm -fR /libexec/
rm -fR /usr/libexec/

# restore script file
safe_copy wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh 775

sleep 2
killall led_error.sh
./led_ok.sh

echo "Reboot ..."
reboot

exit 0



