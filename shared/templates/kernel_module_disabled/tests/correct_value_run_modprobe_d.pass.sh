#!/bin/bash

if [[ ! -d /run/modprobe.d ]]; then
    mkdir -p /run/modprobe.d
fi
echo "install {{{ KERNMODULE }}} /bin/true" > /run/modprobe.d/{{{ KERNMODULE }}}.conf
{{% if "ol" in families or 'rhel' in product or 'almalinux' in product or 'ubuntu' in product or product == "al2023" %}}
echo "blacklist {{{ KERNMODULE }}}" >> /run/modprobe.d/{{{ KERNMODULE }}}.conf
{{% endif %}}
