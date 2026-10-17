#!/bin/bash
# platform = multi_platform_ubuntu

rm -rf /etc/motd.d /run/motd.d /usr/lib/motd.d /run/motd /usr/lib/motd
mkdir -p /etc/update-motd.d /etc/motd.d
rm -f /etc/update-motd.d/*
printf 'Authorized users only. All activity may be monitored and reported.\n' > /etc/motd
printf 'Kernel \\r on an \\m\n' > /etc/motd.d/50-kernel
