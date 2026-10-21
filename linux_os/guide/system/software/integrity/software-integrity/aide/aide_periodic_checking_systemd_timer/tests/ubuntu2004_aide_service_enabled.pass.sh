#!/bin/bash
# platform = Ubuntu 20.04
# packages = aide

cat > /etc/systemd/system/dailyaidecheck.service <<EOF
[Unit]
Description=Daily AIDE check

[Service]
Type=oneshot
ExecStart=/usr/bin/aide.wrapper --check

[Install]
WantedBy=multi-user.target
EOF
cat > /etc/systemd/system/dailyaidecheck.timer <<EOF
[Unit]
Description=Daily AIDE check

[Timer]
OnCalendar=daily

[Install]
WantedBy=timers.target
EOF
systemctl enable dailyaidecheck.service dailyaidecheck.timer
if [[ $(systemctl is-system-running) != "offline" ]]; then
    systemctl daemon-reload
    systemctl start dailyaidecheck.timer
fi
