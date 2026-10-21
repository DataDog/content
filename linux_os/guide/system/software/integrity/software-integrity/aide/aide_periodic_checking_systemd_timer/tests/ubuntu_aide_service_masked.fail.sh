#!/bin/bash
# platform = Ubuntu 22.04,Ubuntu 24.04,Ubuntu 26.04
# packages = aide

systemctl mask dailyaidecheck.service
systemctl enable dailyaidecheck.timer
if [[ $(systemctl is-system-running) != "offline" ]]; then
    systemctl start dailyaidecheck.timer
fi
