#!/bin/bash
# platform = Ubuntu 20.04

# A packages header would install iptables-persistent before every
# scenario of the rule, where it turns the others not applicable.
DEBIAN_FRONTEND=noninteractive apt-get purge -y ufw nftables
DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
