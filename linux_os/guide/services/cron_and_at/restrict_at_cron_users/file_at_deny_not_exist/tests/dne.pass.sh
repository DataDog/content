#!/bin/bash
# packages = at

if [ -f /etc/at.deny ]; then
  rm /etc/at.deny
fi
