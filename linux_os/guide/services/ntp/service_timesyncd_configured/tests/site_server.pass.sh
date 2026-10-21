#!/bin/bash
# platform = Ubuntu 20.04
# packages = systemd

source common.sh
cat <<EOT >/etc/systemd/timesyncd.conf
[Time]
NTP=ntp.example.com
EOT
