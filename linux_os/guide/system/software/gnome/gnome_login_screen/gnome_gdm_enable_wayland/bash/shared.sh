# platform = multi_platform_all

{{% if 'ubuntu' in product %}}
{{% set gdm_conf_path = "/etc/gdm3/custom.conf" %}}
{{% elif 'debian' in product %}}
{{% set gdm_conf_path = "/etc/gdm3/daemon.conf" %}}
{{% else %}}
{{% set gdm_conf_path = "/etc/gdm/custom.conf" %}}
{{% endif %}}

if grep -qPi '^\s*WaylandEnable\s*=' "{{{ gdm_conf_path }}}" 2>/dev/null; then
{{{ bash_ini_file_set(gdm_conf_path, "daemon", "WaylandEnable", "true", rule_id=rule_id) | indent(4) }}}
fi
