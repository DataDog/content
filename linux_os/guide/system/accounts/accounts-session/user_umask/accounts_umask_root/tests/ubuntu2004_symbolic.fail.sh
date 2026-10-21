#!/bin/bash
# platform = Ubuntu 20.04

sed -i '/umask/Id' /root/.bash_profile /root/.bashrc /etc/login.defs 2>/dev/null
echo "UMASK 027" >> /etc/login.defs
echo "umask u=rwx,g=rwx,o=" >> /root/.bashrc
