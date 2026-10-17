#!/bin/bash
# packages = openssh-server

sed -i "/^[[:space:]]*KexAlgorithms/Id" {{{ sshd_main_config_file }}}
mkdir -p {{{ sshd_config_dir }}}
rm -f {{{ sshd_config_dir }}}/*kex*.conf
echo "KexAlgorithms -diffie-hellman-group1-sha1,sntrup*" > {{{ sshd_config_dir }}}/50-kex.conf
