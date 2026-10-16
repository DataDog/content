#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults env_reset' > /etc/sudoers
echo 'Defaults timestamp_type=global # one record for every session' >> /etc/sudoers
chmod 440 /etc/sudoers
