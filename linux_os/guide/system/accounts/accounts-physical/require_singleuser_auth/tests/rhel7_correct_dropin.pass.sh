#!/bin/bash
# platform = Red Hat Enterprise Linux 7

rm -rf /etc/systemd/system/rescue.service.d
mkdir -p /etc/systemd/system/rescue.service.d
cat << 'EOF2' > /etc/systemd/system/rescue.service.d/10-automatus.conf
[Service]
ExecStart=
ExecStart=-/bin/sh -c "/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"
EOF2
