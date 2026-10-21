#!/bin/bash
{{% if product == "ubuntu2004" %}}
# packages = systemd-coredump
{{% endif %}}

source common.sh

echo ProcessSizeMax=0 >> /etc/systemd/coredump.conf
