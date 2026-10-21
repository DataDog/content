#!/bin/bash
# packages = chrony

# Installing chrony removes systemd-timesyncd, whose daemon keeps running
# where policy-rc.d denies service actions to package scripts.
systemctl stop systemd-timesyncd.service || true
systemctl unmask chrony.service
systemctl enable chrony.service
systemctl start chrony.service
