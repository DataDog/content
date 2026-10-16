#!/bin/bash
# packages = gdm

mkdir -p /etc/gdm
printf '%s\n' "# comment" "[daemon]" "WaylandEnable=false" > /etc/gdm/custom.conf
