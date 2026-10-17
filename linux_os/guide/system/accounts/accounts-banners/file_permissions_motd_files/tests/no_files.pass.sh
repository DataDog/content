#!/bin/bash
# platform = multi_platform_ubuntu

rm -rf /etc/motd.d /run/motd.d /usr/lib/motd.d /run/motd /usr/lib/motd /etc/motd
mkdir -p /etc/update-motd.d
rm -f /etc/update-motd.d/*
