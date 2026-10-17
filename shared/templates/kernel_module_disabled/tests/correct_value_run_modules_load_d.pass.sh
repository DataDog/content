#!/bin/bash

if [[ ! -d /run/modules-load.d ]]; then
    mkdir -p /run/modules-load.d
fi

echo "install {{{ KERNMODULE }}} /bin/true" > /run/modules-load.d/{{{ KERNMODULE }}}.conf
{{% if "ol" in families or 'rhel' in product or 'almalinux' in product or 'ubuntu' in product or product == "al2023" %}}
echo "blacklist {{{ KERNMODULE }}}" >> /run/modules-load.d/{{{ KERNMODULE }}}.conf
{{% endif %}}
