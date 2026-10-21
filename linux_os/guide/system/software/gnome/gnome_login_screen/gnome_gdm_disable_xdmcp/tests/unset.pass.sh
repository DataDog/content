#!/bin/bash
# packages = gdm
# platform = Red Hat Enterprise Linux 7

printf '%s\n' "# comment" "[xdmcp]" "[debug]" "#Enable=true" > /etc/gdm/custom.conf
