#!/bin/bash
# packages = systemd

source common.sh
cat <<EOT >/etc/systemd/timesyncd.conf
[Time]
NTP=
FallbackNTP=
EOT
