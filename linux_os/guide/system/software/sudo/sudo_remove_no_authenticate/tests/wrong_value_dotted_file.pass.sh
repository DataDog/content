#!/bin/bash
# packages = sudo
echo "Defaults authenticate" > /etc/sudoers
echo "#includedir /etc/sudoers.d" >> /etc/sudoers
chmod 440 /etc/sudoers

mkdir -p /etc/sudoers.d
# sudo skips the files of /etc/sudoers.d whose names contain a "." or end in "~"
echo "Defaults !authenticate" > /etc/sudoers.d/sudoers.rpmsave
echo "Defaults !authenticate" > /etc/sudoers.d/sudoers~
