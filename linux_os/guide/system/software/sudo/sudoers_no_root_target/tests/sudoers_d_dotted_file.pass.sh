#!/bin/bash
# platform = multi_platform_all
# packages = sudo

echo '%wheel ALL=(admin) ALL' > /etc/sudoers
echo 'user ALL=(admin) ALL' > /etc/sudoers.d/foo
# sudo skips the files of /etc/sudoers.d whose names contain a "."
echo 'user ALL=(ALL) ALL' > /etc/sudoers.d/foo.rpmsave
{{% if product in [ 'sle16', 'slmicro6' ] %}}
sed -i "/^ALL[[:space:]]*ALL=(ALL)[[:space:]]*ALL/d" /usr/etc/sudoers
{{% endif %}}
