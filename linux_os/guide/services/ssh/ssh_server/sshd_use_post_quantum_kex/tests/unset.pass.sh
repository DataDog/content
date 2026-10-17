#!/bin/bash
# packages = openssh-server

sed -i "/^[[:space:]]*KexAlgorithms/Id" {{{ sshd_main_config_file }}}
rm -f {{{ sshd_config_dir }}}/*kex*.conf
