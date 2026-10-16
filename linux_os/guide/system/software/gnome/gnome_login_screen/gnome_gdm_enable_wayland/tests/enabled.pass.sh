#!/bin/bash
# packages = gdm

mkdir -p /etc/gdm
printf '%s\n' "[daemon]" "WaylandEnable=true" > /etc/gdm/custom.conf
