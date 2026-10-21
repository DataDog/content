#!/bin/bash
# platform = Red Hat Enterprise Linux 7

rm -f /etc/systemd/system/emergency.service
mkdir -p /etc/systemd/system/emergency.service.d
cat << 'EOF2' > /etc/systemd/system/emergency.service.d/10-automatus.conf
[Service]
Environment=LANG=C
EOF2
