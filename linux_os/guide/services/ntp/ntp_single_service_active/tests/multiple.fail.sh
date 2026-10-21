#!/bin/bash
# packages = chrony
# remediation = none

# chrony and systemd-timesyncd conflict on the products that select this
# rule, so a unit of the same name stands in for the second daemon.
systemctl stop systemd-timesyncd.service || true
systemctl unmask systemd-timesyncd.service
cat >/etc/systemd/system/systemd-timesyncd.service <<EOT
[Service]
ExecStart=/bin/sleep infinity

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload

systemctl unmask chrony.service
systemctl enable chrony.service
systemctl start chrony.service
systemctl enable systemd-timesyncd.service
systemctl start systemd-timesyncd.service
