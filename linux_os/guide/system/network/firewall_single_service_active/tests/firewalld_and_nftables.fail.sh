#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = firewalld,nftables
# remediation = none

systemctl unmask firewalld nftables
systemctl enable firewalld nftables
systemctl start firewalld nftables
