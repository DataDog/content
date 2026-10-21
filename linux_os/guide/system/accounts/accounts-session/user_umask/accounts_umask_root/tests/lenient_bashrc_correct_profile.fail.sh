#!/bin/bash
{{%- if product == "ubuntu2004" %}}
# platform = Not Applicable
{{%- else %}}
# platform = multi_platform_all
{{%- endif %}}
{{%- set root_profile = "/root/.bash_profile" if product == "rhel7" else "/root/.profile" %}}

sed '/umask/d' -i /root/.bashrc {{{ root_profile }}} || true
echo "umask 0000" >> /root/.bashrc
echo "umask 0027" >> {{{ root_profile }}}
