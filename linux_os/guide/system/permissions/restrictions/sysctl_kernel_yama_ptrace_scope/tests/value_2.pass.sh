#!/bin/bash
# platform = Ubuntu 20.04

# CIS Ubuntu 20.04 1.5.2 accepts kernel.yama.ptrace_scope set to 1, 2 or 3.
rm -rf /usr/lib/sysctl.d/* /run/sysctl.d/* /etc/sysctl.d/* /etc/ufw/sysctl.conf
sed -i "/kernel.yama.ptrace_scope/d" /etc/sysctl.conf
echo "kernel.yama.ptrace_scope = 2" >> /etc/sysctl.d/60-ptrace.conf
sysctl -w kernel.yama.ptrace_scope=2
