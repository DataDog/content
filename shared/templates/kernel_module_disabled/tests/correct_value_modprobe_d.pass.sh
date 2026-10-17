#!/bin/bash

echo "install {{{ KERNMODULE }}} /bin/false" > /etc/modprobe.d/{{{ KERNMODULE }}}.conf
{{% if "ol" in families or 'rhel' in product or 'almalinux' in product or 'ubuntu' in product or product == "al2023" %}}
echo "blacklist {{{ KERNMODULE }}}" >> /etc/modprobe.d/{{{ KERNMODULE }}}.conf
{{% endif %}}
