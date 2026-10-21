#!/bin/bash
{{% if product == "ubuntu2004" %}}
# packages = systemd-coredump
{{% endif %}}

echo Storage=persistent >> /etc/systemd/coredump.conf
