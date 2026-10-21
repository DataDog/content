#!/bin/bash
# platform = Red Hat Enterprise Linux 7

sed -i 's/gpgcheck\s*=.*/gpgcheck=2/g' /etc/yum.repos.d/*
