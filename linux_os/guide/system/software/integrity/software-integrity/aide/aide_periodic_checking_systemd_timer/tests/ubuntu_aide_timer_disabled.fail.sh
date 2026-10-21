#!/bin/bash
# platform = Ubuntu 22.04,Ubuntu 24.04,Ubuntu 26.04
# packages = aide

systemctl enable dailyaidecheck.service
systemctl disable dailyaidecheck.timer
if [[ $(systemctl is-system-running) != "offline" ]]; then
    systemctl stop dailyaidecheck.timer
fi
