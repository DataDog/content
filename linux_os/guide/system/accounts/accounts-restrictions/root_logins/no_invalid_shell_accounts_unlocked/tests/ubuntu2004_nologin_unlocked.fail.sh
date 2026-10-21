#!/bin/bash
# platform = Ubuntu 20.04

useradd -s /usr/sbin/nologin cacsvc
echo "cacsvc:Pa55w0rd!q" | chpasswd
