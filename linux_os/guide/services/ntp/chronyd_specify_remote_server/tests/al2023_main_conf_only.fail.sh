#!/bin/bash
# packages = chrony
# platform = Amazon Linux 2023

rm -rf /etc/chrony.d
echo "server 169.254.169.123 prefer iburst" >>{{{ chrony_conf_path }}}
