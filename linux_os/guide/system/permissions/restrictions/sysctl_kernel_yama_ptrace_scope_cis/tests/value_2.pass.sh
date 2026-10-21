#!/bin/bash

# Clean sysctl config directories
rm -rf /usr/lib/sysctl.d/* /run/sysctl.d/* /etc/sysctl.d/*

sed -i "/kernel.yama.ptrace_scope/d" /etc/sysctl.conf
echo "kernel.yama.ptrace_scope = 2" >> /etc/sysctl.conf

# set correct runtime value to check if the filesystem configuration is evaluated properly
sysctl -w kernel.yama.ptrace_scope="2"
