#!/bin/bash
# packages = gdm
{{% if product == "rhel7" %}}
# platform = Not Applicable
{{% endif %}}

printf '%s\n' "# comment" "[xdmcp]" > /etc/gdm/custom.conf
