#!/bin/bash
# packages = at

useradd testuser_123
touch /etc/at.deny
chown testuser_123 /etc/at.deny
