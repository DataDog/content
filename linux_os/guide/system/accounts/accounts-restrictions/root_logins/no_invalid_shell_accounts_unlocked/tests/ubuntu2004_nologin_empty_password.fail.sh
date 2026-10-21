#!/bin/bash
# platform = Ubuntu 20.04

# passwd -S reports an empty password field as NP.
useradd -s /usr/sbin/nologin cacsvc
sed -i 's/^cacsvc:[^:]*:/cacsvc::/' /etc/shadow
