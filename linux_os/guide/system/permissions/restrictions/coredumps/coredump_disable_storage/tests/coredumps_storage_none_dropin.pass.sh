#!/bin/bash
{{% if product == "ubuntu2004" %}}
# packages = systemd-coredump
{{% endif %}}
mkdir -p /etc/systemd/coredump.conf.d
echo [Coredump] > /etc/systemd/coredump.conf
echo [Coredump] > /etc/systemd/coredump.conf.d/private.conf
echo Storage=none >> /etc/systemd/coredump.conf.d/private.conf
