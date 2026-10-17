#!/bin/bash
# packages = sudo

sed -i '/timestamp_timeout/d' /etc/sudoers
echo "Defaults timestamp_timeout=5" >> /etc/sudoers
echo "Defaults:root timestamp_timeout=-1" >> /etc/sudoers
