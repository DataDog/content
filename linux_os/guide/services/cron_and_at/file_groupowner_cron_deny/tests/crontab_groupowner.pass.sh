#!/bin/bash
# platform = Ubuntu 20.04

getent group crontab >/dev/null || groupadd crontab
touch /etc/cron.deny
chgrp crontab /etc/cron.deny
