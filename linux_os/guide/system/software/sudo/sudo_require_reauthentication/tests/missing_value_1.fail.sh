#!/bin/bash
# packages = sudo
# variables = var_sudo_timestamp_timeout=0

{{% if product in [ 'sle16', 'slmicro6' ] %}}
touch /etc/sudoers
{{% endif %}}
# Remove Defaults timestamp_timeout from /etc/sudoers
if grep -q 'timestamp_timeout' /etc/sudoers; then
	sed -i '/.*timestamp_timeout.*/d' /etc/sudoers
fi

# Remove Defaults timestamp_timeout from /etc/sudoers.d/00-complianceascode-test
if grep -q 'timestamp_timeout' /etc/sudoers.d/00-complianceascode-test; then
	sed -i '/.*timestamp_timeout.*/d' /etc/sudoers.d/00-complianceascode-test
fi
