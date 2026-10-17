#!/bin/bash
# variables = sysctl_net_ipv4_conf_default_forwarding_value=0,var_sysctl_ip_forward_counts_for_forwarding=false

# Clean sysctl config directories
{{% if "ubuntu" in product %}}
rm -rf /usr/lib/sysctl.d/* /run/sysctl.d/* /etc/sysctl.d/* /etc/ufw/sysctl.conf
{{% else %}}
rm -rf /usr/lib/sysctl.d/* /run/sysctl.d/* /etc/sysctl.d/*
{{% endif %}}

sed -i "/net.ipv4.conf.default.forwarding/d; /net.ipv4.ip_forward/d" /etc/sysctl.conf
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf

sysctl -w net.ipv4.ip_forward=0
