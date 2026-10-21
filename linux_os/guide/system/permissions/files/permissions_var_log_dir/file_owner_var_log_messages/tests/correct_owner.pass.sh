#!/bin/bash
# platform = Ubuntu 20.04,Ubuntu 24.04

id syslog &>/dev/null || useradd syslog
touch /var/log/messages
chown syslog /var/log/messages
