#!/bin/bash
# platform = Ubuntu 20.04

sed -i '/umask/Id' /root/.bash_profile /root/.bashrc /etc/login.defs 2>/dev/null
echo "UMASK		022" >> /etc/login.defs
