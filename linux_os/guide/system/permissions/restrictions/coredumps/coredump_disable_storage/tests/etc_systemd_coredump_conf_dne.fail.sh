#!/bin/bash
{{% if product == "ubuntu2004" %}}
# packages = systemd-coredump
{{% endif %}}
FILE="/etc/systemd/coredump.conf"
if [ -f $FILE ]; then
    rm $FILE
fi

