#!/bin/bash
# packages = gdm
# platform = Red Hat Enterprise Linux 7,Ubuntu 20.04
{{%- set gdm_conf_path = "/etc/gdm3/custom.conf" if product == "ubuntu2004" else "/etc/gdm/custom.conf" %}}

printf '%s\n' "# comment" "[xdmcp]" "[debug]" "#Enable=true" > {{{ gdm_conf_path }}}
