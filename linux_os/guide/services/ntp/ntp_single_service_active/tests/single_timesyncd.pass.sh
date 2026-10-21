#!/bin/bash
# packages = systemd-timesyncd

systemctl unmask systemd-timesyncd.service
systemctl enable systemd-timesyncd.service
systemctl start systemd-timesyncd.service
