#!/bin/bash
# platform = Ubuntu 20.04
# packages = iptables-persistent

DEBIAN_FRONTEND=noninteractive apt-get purge -y ufw nftables
