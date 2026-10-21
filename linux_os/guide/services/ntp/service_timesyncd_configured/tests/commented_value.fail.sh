#!/bin/bash
# packages = systemd

source common.sh
cat <<EOT >/etc/systemd/timesyncd.conf
[Time]
#NTP=time.nist.gov
#FallbackNTP=time-a-g.nist.gov
EOT
