#!/bin/bash
# packages = at

useradd testuser_123
touch /etc/at.allow
chown testuser_123 /etc/at.allow
