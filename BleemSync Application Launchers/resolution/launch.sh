#!/bin/sh
echo launch_StockUI > "/tmp/launchfilecommand"
systemctl stop weston
cp "/etc/xdg/weston/weston.ini" "/tmp/"
sed -i "s/mode=1280x720/mode=1920x1080/" "/tmp/weston.ini"
mount -o bind "/tmp/weston.ini" "/etc/xdg/weston/weston.ini"
systemctl start weston
exit