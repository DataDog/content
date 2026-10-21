#!/bin/bash
# platform = Ubuntu 20.04
# packages = ufw

sed -i '/^-A ufw6\?-before-\(input -i\|output -o\) lo -j ACCEPT/d' /etc/ufw/before.rules /etc/ufw/before6.rules
ufw --force enable
ufw deny in from 127.0.0.0/8
ufw deny in from ::1
