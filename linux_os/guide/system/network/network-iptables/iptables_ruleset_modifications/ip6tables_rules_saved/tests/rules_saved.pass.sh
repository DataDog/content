#!/bin/bash
# packages = iptables-services

ip6tables -F
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -s ::1 -j DROP
ip6tables -A OUTPUT -o lo -j ACCEPT
ip6tables -P INPUT DROP
ip6tables-save > /etc/sysconfig/ip6tables
