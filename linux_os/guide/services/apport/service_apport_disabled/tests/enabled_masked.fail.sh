#!/bin/bash
# packages = apport

sed -i '/^[[:space:]]*enabled[[:space:]]*=/Id' /etc/default/apport
echo 'enabled=1' >> /etc/default/apport

systemctl stop apport.service
systemctl mask apport.service
systemctl reset-failed apport.service || true
