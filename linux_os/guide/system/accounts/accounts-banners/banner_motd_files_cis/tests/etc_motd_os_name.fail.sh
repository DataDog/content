#!/bin/bash
# platform = multi_platform_ubuntu

rm -rf /etc/motd.d /run/motd.d /usr/lib/motd.d /run/motd /usr/lib/motd
mkdir -p /etc/update-motd.d
rm -f /etc/update-motd.d/*
printf 'Welcome to Ubuntu!\n' > /etc/motd
