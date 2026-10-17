#!/bin/bash

echo "install {{{ KERNMODULE }}} /bin/true" > /etc/modules-load.d/{{{ KERNMODULE }}}.conf
{{% if "ol" in families or 'rhel' in product or 'almalinux' in product or 'ubuntu' in product or product == "al2023" %}}
echo "blacklist {{{ KERNMODULE }}}" >> /etc/modules-load.d/{{{ KERNMODULE }}}.conf
{{% endif %}}
