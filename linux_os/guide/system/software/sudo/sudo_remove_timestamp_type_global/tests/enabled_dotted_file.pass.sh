#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults env_reset' > /etc/sudoers
echo '#includedir /etc/sudoers.d' >> /etc/sudoers
chmod 440 /etc/sudoers
mkdir -p /etc/sudoers.d
# sudo skips the files of /etc/sudoers.d whose names contain a "." or end in "~"
echo 'Defaults timestamp_type=global' > /etc/sudoers.d/cis_sudoers.conf
echo 'Defaults timestamp_type=global' > /etc/sudoers.d/cis~
chmod 440 /etc/sudoers.d/cis_sudoers.conf /etc/sudoers.d/cis~
