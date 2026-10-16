#!/bin/bash
# platform = Red Hat Enterprise Linux 8,Red Hat Enterprise Linux 9,Red Hat Enterprise Linux 10,AlmaLinux OS 9

dnf -y remove firewalld
dnf -y install nftables
systemctl enable nftables
