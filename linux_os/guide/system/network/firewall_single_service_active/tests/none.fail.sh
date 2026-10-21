#!/bin/bash
# platform = multi_platform_debian,multi_platform_ubuntu
#
# remediation = none

apt install -y iptables nftables ufw
systemctl stop iptables
systemctl stop nftables
systemctl stop ufw
