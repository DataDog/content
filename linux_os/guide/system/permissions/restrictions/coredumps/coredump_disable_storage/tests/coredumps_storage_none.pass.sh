#!/bin/bash
{{% if product == "ubuntu2004" %}}
# packages = systemd-coredump
{{% endif %}}
mkdir -p /etc/systemd/

if ! grep -q "[Coredump]" /etc/systemd/coredump.conf; then
    echo "[Coredump]" >> /etc/systemd/coredump.conf
fi
echo Storage=none >> /etc/systemd/coredump.conf
