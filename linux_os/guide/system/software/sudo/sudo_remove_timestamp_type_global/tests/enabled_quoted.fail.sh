#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults env_reset' > /etc/sudoers
echo 'Defaults timestamp_type="global",logfile=/var/log/sudo.log' >> /etc/sudoers
chmod 440 /etc/sudoers
