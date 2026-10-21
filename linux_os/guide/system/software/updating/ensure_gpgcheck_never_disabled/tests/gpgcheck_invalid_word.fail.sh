#!/bin/bash
# platform = Red Hat Enterprise Linux 7

sed -i 's/gpgcheck\s*=.*/gpgcheck=enabled/g' /etc/yum.repos.d/*
