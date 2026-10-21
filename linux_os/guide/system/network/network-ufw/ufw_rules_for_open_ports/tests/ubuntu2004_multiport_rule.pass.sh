#!/bin/bash
# platform = Ubuntu 20.04
# packages = ufw

source ubuntu2004_common.sh
ufw allow 80,5000/tcp
