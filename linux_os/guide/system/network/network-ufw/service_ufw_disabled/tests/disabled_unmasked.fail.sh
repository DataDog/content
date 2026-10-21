#!/bin/bash
# platform = multi_platform_ubuntu
# packages = ufw,iptables-persistent

systemctl unmask ufw.service
systemctl disable ufw.service
