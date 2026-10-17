#!/bin/bash
# platform = multi_platform_ubuntu

rm -rf /etc/motd.d /run/motd.d /usr/lib/motd.d /run/motd /usr/lib/motd
mkdir -p /etc/update-motd.d
rm -f /etc/update-motd.d/*
printf 'Authorized users only. All activity may be monitored and reported.\n' > /etc/motd
printf '#!/bin/sh\nprintf "Authorized users only.\\n"\n' > /etc/update-motd.d/00-header
chown root:root /etc/motd /etc/update-motd.d/00-header
chmod 0644 /etc/motd /etc/update-motd.d/00-header
