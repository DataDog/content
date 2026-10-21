#!/bin/bash
# packages = gdm
{{% if product == "rhel7" %}}
# platform = Not Applicable
{{% endif %}}

mkdir -p /etc/gdm
rm -f /etc/gdm/custom.conf
