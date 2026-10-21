#!/bin/bash
# packages = gdm
{{% if 'ubuntu' in product %}}
{{% set gdm_conf_path = "/etc/gdm3/custom.conf" %}}
{{% elif 'debian' in product %}}
{{% set gdm_conf_path = "/etc/gdm3/daemon.conf" %}}
{{% else %}}
{{% set gdm_conf_path = "/etc/gdm/custom.conf" %}}
{{% endif %}}

mkdir -p "$(dirname {{{ gdm_conf_path }}})"
printf '%s\n' "# comment" "[xdmcp]" "# Enable=true" "Enable=false" > {{{ gdm_conf_path }}}
