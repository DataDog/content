#!/bin/bash
# packages = sudo
echo "%wheel	ALL=(ALL)	ALL" > /etc/sudoers
echo "#includedir /etc/sudoers.d" >> /etc/sudoers
chmod 440 /etc/sudoers

mkdir -p /etc/sudoers.d
echo "vdsm ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/50_vdsm
# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/sudoers.rpmsave
