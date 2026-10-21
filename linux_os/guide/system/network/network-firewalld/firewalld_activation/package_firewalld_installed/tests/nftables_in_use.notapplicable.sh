#!/bin/bash
# platform = Red Hat Enterprise Linux 7

yum -y remove firewalld
yum -y install nftables
systemctl enable nftables
