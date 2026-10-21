#!/bin/bash
# platform = Ubuntu 20.04
# variables = var_package_latest_version_required=false

# Install the oldest apparmor-utils the repositories offer, so that apt lists an upgrade.
apt-get update -qq
version=$(apt-cache madison apparmor-utils | awk 'END { print $3 }')
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --allow-downgrades "apparmor=$version" "apparmor-utils=$version" "python3-apparmor=$version" "python3-libapparmor=$version" "libapparmor1=$version"
