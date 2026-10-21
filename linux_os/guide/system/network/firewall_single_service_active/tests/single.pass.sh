#!/bin/bash
# platform = multi_platform_debian,multi_platform_ubuntu

apt install -y iptables nftables ufw
systemctl stop iptables
systemctl stop nftables
systemctl stop ufw
systemctl start ufw
