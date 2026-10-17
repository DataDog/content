#!/bin/bash
# platform = multi_platform_ubuntu

rm -rf /etc/motd.d /run/motd.d /usr/lib/motd.d /run/motd /usr/lib/motd
mkdir -p /etc/update-motd.d
rm -f /etc/update-motd.d/*
printf 'Authorized users only. All activity may be monitored and reported.\n' > /etc/motd
printf '#!/bin/sh\nprintf " * Documentation:  https://help.ubuntu.com\\n"\n' > /etc/update-motd.d/10-help-text
chmod 0755 /etc/update-motd.d/10-help-text
