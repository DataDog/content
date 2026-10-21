#!/bin/bash
# platform = Ubuntu 20.04
# packages = iptables-persistent
# variables = var_service_disabled_mask_optional=true

DEBIAN_FRONTEND=noninteractive apt-get purge -y nftables
