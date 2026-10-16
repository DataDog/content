#!/bin/bash
# packages = gdm

mkdir -p /etc/gdm
printf '%s\n' "# comment" "[daemon]" > /etc/gdm/custom.conf
