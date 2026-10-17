#!/bin/bash
# packages = gdm

mkdir -p /etc/gdm
printf '%s\n' "[daemon]" "#WaylandEnable=false" > /etc/gdm/custom.conf
