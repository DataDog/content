#!/bin/bash
# packages = sudo

rm -f /etc/sudoers.d/*
echo 'Defaults timestamp_type=tty' > /etc/sudoers
chmod 440 /etc/sudoers
