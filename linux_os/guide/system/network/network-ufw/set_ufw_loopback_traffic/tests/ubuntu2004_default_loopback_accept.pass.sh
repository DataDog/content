#!/bin/bash
# platform = Ubuntu 20.04
# packages = ufw

ufw --force enable
ufw deny in from 127.0.0.0/8
ufw deny in from ::1
