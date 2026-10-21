#!/bin/bash
# platform = Ubuntu 20.04

# passwd -l prefixes the hash with !, which passwd -S reports as L.
useradd -s /usr/sbin/nologin cacsvc
echo "cacsvc:Pa55w0rd!q" | chpasswd
passwd -l cacsvc
