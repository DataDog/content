#!/bin/bash
{{% if not FSTAB_ENTRY_OPTIONAL %}}
# platform = Not Applicable
{{% endif %}}

# The active mount carries the option, and /etc/fstab has no entry for it.
sed -i '\|[[:space:]]{{{ MOUNTPOINT }}}[[:space:]]|d' /etc/fstab
mount -o remount,{{{ MOUNTOPTION }}} {{{ MOUNTPOINT }}} || true
