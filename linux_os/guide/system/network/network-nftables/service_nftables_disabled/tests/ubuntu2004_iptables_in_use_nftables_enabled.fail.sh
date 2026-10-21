#!/bin/bash
# platform = Ubuntu 20.04
# packages = nftables,iptables-persistent

systemctl unmask nftables.service
systemctl enable nftables.service
