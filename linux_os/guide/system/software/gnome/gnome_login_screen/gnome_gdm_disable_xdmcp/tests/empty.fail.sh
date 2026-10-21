#!/bin/bash
# packages = gdm
{{% if product in ["rhel7", "ubuntu2004"] %}}
# platform = Not Applicable
{{% endif %}}
{{% if 'ubuntu' in product %}}
{{% set gdm_conf_path = "/etc/gdm3/custom.conf" %}}
{{% elif 'debian' in product %}}
{{% set gdm_conf_path = "/etc/gdm3/daemon.conf" %}}
{{% else %}}
{{% set gdm_conf_path = "/etc/gdm/custom.conf" %}}
{{% endif %}}

mkdir -p "$(dirname {{{ gdm_conf_path }}})"
printf '%s\n' "# comment" "[xdmcp]" > {{{ gdm_conf_path }}}
