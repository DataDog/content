#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = firewalld

systemctl stop nftables iptables ip6tables
systemctl disable nftables iptables ip6tables
systemctl unmask firewalld
systemctl enable firewalld
systemctl start firewalld
