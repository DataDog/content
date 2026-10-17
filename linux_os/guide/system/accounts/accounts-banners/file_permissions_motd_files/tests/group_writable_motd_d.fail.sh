#!/bin/bash
# platform = multi_platform_ubuntu

rm -rf /etc/motd.d /run/motd.d /usr/lib/motd.d /run/motd /usr/lib/motd
mkdir -p /etc/update-motd.d /usr/lib/motd.d
rm -f /etc/update-motd.d/*
printf 'Authorized users only. All activity may be monitored and reported.\n' > /etc/motd
printf 'Authorized users only.\n' > /usr/lib/motd.d/50-site
chown root:root /etc/motd /usr/lib/motd.d/50-site
chmod 0644 /etc/motd
chmod 0664 /usr/lib/motd.d/50-site
