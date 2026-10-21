#!/bin/bash
# platform = Ubuntu 20.04
# variables = var_package_latest_version_required=true

# Install the oldest PAM packages the repositories offer, so that apt lists an upgrade.
apt-get update -qq
version=$(apt-cache madison libpam-modules | awk 'END { print $3 }')
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --allow-downgrades "libpam-runtime=$version" "libpam-modules=$version" "libpam-modules-bin=$version" "libpam0g=$version"
