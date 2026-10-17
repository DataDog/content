#!/bin/bash
# platform = multi_platform_ubuntu

rm -rf /etc/motd.d /run/motd.d /usr/lib/motd.d /run/motd /usr/lib/motd /etc/motd
mkdir -p /etc/update-motd.d
rm -f /etc/update-motd.d/*
printf 'Authorized users only. All activity may be monitored and reported.\n' > /etc/motd.cac
chown root:root /etc/motd.cac
chmod 0666 /etc/motd.cac
ln -s /etc/motd.cac /etc/motd
