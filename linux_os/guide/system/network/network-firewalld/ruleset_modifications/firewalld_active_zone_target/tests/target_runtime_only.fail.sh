#!/bin/bash
# packages = firewalld
# remediation = none

systemctl start firewalld
zone=$(firewall-cmd --get-default-zone)
firewall-cmd --permanent --zone="$zone" --set-target=DROP
firewall-cmd --reload
firewall-cmd --permanent --zone="$zone" --set-target=default
