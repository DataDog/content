#!/bin/bash
# platform = Ubuntu 20.04

sed -i '/^\s*umask\s/Id' /root/.bash_profile /root/.bashrc 2>/dev/null
echo "umask 022&& export FOO=bar" >> /root/.bash_profile
