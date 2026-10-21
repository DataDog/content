#!/bin/bash
# platform = Ubuntu 20.04

useradd -s /bin/false cacsvc
echo "cacsvc:Pa55w0rd!q" | chpasswd
