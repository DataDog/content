#!/bin/bash
# platform = Ubuntu 22.04,Ubuntu 24.04

DEBIAN_FRONTEND=noninteractive apt-get purge -y ufw nftables
DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
