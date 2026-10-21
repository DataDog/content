#!/bin/bash
# platform = Ubuntu 20.04

# A system without a dedicated syslog user, as with journald alone.
userdel -r syslog 2>/dev/null || true

useradd -m -s /usr/sbin/nologin test_user_no_shell

chown root:root -R /var/log/*

touch /var/log/test_log_file
chown test_user_no_shell /var/log/test_log_file
