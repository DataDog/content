#!/bin/bash
# platform = Red Hat Enterprise Linux 7
# packages = iptables-services

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
