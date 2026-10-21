# platform = multi_platform_all

{{% if product in ["rhel7"] -%}}
service_file="/usr/lib/systemd/system/rescue.service"
sulogin='/bin/sh -c "/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"'

if grep -q "^ExecStart=" "$service_file"; then
    sed -i "s%^ExecStart=.*%ExecStart=-$sulogin%" "$service_file"
else
    echo "ExecStart=-$sulogin" >> "$service_file"
fi

# An ExecStart in a drop-in replaces the one of the unit file.
for f in /etc/systemd/system/rescue.service.d/*.conf; do
    if [ -e "$f" ]; then
        sed -i '/^[[:space:]]*ExecStart[[:space:]]*=/d' "$f"
    fi
done
{{%- else -%}}
{{%- if product in ["fedora", "sle12", "sle15", "sle16", "slmicro5", "slmicro6"] or 'ol' in families or 'rhel' in product -%}}
{{% set sulogin="\\nExecStart=-/usr/lib/systemd/systemd-sulogin-shell rescue" %}}
{{%- else -%}}
{{% set sulogin='-/bin/sh -c "/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"'  %}}
{{%- endif %}}

{{{ bash_ensure_ini_config("/etc/systemd/system/rescue.service.d/10-oscap.conf /etc/systemd/system/rescue.service.d/*.conf", "Service", "ExecStart", sulogin) }}}
{{%- endif %}}
