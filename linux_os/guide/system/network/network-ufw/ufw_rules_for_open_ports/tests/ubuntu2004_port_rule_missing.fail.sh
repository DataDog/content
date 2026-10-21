#!/bin/bash
# platform = Ubuntu 20.04
# packages = ufw
# remediation = none

source ubuntu2004_common.sh
ufw allow 50000/tcp
