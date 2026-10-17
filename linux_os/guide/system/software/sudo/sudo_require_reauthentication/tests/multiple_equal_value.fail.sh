#!/bin/bash
# packages = sudo

# Set Defaults timestamp_timeout in /etc/sudoers 
if grep -q 'timestamp_timeout' /etc/sudoers; then
	sed -i 's/.*timestamp_timeout.*/Defaults timestamp_timeout=3/' /etc/sudoers
else
	echo "Defaults timestamp_timeout=3" >> /etc/sudoers
fi

# Set Defaults timestamp_timeout in /etc/sudoers.d/00-complianceascode-test
if grep -q 'timestamp_timeout' /etc/sudoers.d/00-complianceascode-test; then
	sed -i 's/.*timestamp_timeout.*/Defaults timestamp_timeout=3/' /etc/sudoers.d/00-complianceascode-test
else
	echo "Defaults timestamp_timeout=3" >> /etc/sudoers.d/00-complianceascode-test
fi
