#!/bin/bash
# packages = sudo
echo "%wheel	ALL=(ALL)	ALL" > /etc/sudoers
echo "#includedir /etc/sudoers.d" >> /etc/sudoers
chmod 440 /etc/sudoers

mkdir -p /etc/sudoers.d
# sudo skips the files of /etc/sudoers.d whose names contain a "." or end in "~"
echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/sudoers.rpmsave
echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/sudoers~
