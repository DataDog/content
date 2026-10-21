#!/bin/bash
# platform = Ubuntu 20.04,Ubuntu 24.04

getent group "adm" &>/dev/null || groupadd adm
touch /var/log/messages
chgrp root /var/log/messages
