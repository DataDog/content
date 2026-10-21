#!/bin/bash
# packages = chrony
# remediation = none

systemctl stop systemd-timesyncd.service || true
systemctl stop chrony.service
systemctl disable chrony.service
