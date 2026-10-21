#!/bin/bash
# platform = Ubuntu 20.04

sed -i '/umask/Id' /root/.bash_profile /root/.bashrc /etc/login.defs 2>/dev/null
echo "umask 0027" >> /root/.bashrc
echo "umask 077" >> /root/.bash_profile
echo "UMASK 027" >> /etc/login.defs
