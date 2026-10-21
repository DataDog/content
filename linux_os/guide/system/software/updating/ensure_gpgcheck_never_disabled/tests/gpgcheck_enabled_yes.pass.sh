#!/bin/bash
# platform = Red Hat Enterprise Linux 7

sed -i 's/gpgcheck\s*=.*/gpgcheck=yes/g' /etc/yum.repos.d/*
