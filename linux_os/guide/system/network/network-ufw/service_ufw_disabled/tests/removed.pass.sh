#!/bin/bash
# platform = multi_platform_ubuntu
# packages = iptables-persistent

DEBIAN_FRONTEND=noninteractive apt-get purge -y ufw
