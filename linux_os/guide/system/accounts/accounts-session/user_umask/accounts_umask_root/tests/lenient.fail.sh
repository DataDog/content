#!/bin/bash
{{%- set root_profile = "/root/.bash_profile" if product == "rhel7" else "/root/.profile" %}}

sed '/umask/d' -i /root/.bashrc {{{ root_profile }}} || true
echo "umask 0022" >> {{{ root_profile }}}
