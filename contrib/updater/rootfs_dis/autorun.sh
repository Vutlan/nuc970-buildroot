#!/bin/sh

echo "******************************************"
echo "* Disable gsmmodemd (script ver.0.9)"
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

        echo "  copy file: $file_dst"

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

rm -f /opt/xmon/etc/services/S25gsmmodemd
safe_copy wd/S25gsmmodemd /opt/xmon/etc/services/S25gsmmodemd 775

rm -f /opt/xmon/bin/xmoncheck.sh
safe_copy wd/xmoncheck.sh /opt/xmon/bin/xmoncheck.sh 775

sleep 2
killall led_error.sh
./led_ok.sh

echo "Reboot ..."
reboot

exit 0


