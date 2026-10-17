# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low


{{{ bash_instantiate_variables("var_sudo_timestamp_timeout") }}}

{{% if product in [ 'sle16', 'slmicro6' ] %}}
{{{ bash_copy_distro_defaults("/usr/etc/sudoers", "/etc/sudoers") }}}
{{{ lineinfile_absent("/etc/sudoers", "^\s*@includedir\s*/usr/etc/sudoers\.d", sed_path_separator="#", rule_id=rule_id) }}}
{{% endif %}}

if grep -Px '^[\s]*Defaults.*timestamp_timeout[\s]*=.*' /etc/sudoers.d/*; then
    find /etc/sudoers.d/ -type f -exec sed -Ei "/^[[:blank:]]*Defaults.*timestamp_timeout[[:blank:]]*=.*/d" {} \;
fi

if /usr/sbin/visudo -qcf /etc/sudoers; then
    cp /etc/sudoers /etc/sudoers.bak
    chmod 0440 /etc/sudoers.bak
    # Set every timestamp_timeout value, signed, fractional or quoted, to the required one
    sed -Ei "s/(^[[:blank:]]*Defaults.*timestamp_timeout[[:blank:]]*=)[[:blank:]]*\"?[-+]?[0-9.]+\"?/\1${var_sudo_timestamp_timeout}/" /etc/sudoers
    # Keep one Defaults entry for all users: take timestamp_timeout out of
    # every entry, drop the entries left empty, and add it back below
    if [ "$(grep -cP '^[\s]*Defaults[\s]+(.*[\s,])?timestamp_timeout[\s]*=' /etc/sudoers)" -gt 1 ]; then
        sed -Ei -e '/^[[:blank:]]*Defaults[[:blank:]]/ s/[[:blank:]]*,[[:blank:]]*timestamp_timeout[[:blank:]]*=[[:blank:]]*[^,#[:blank:]]*//g' \
            -e '/^[[:blank:]]*Defaults[[:blank:]]/ s/^([[:blank:]]*Defaults[[:blank:]]+)timestamp_timeout[[:blank:]]*=[[:blank:]]*[^,#[:blank:]]*[[:blank:]]*,[[:blank:]]*/\1/' \
            -e '/^[[:blank:]]*Defaults[[:blank:]]+timestamp_timeout[[:blank:]]*=[^,#]*(#.*)?$/d' /etc/sudoers
    fi
    if ! grep -qP '^[\s]*Defaults[\s]+(.*[\s,])?timestamp_timeout[\s]*=' /etc/sudoers; then
        # sudoers file doesn't define Option timestamp_timeout for all users
        echo "Defaults timestamp_timeout=${var_sudo_timestamp_timeout}" >> /etc/sudoers
    fi

    # Check validity of sudoers and cleanup bak
    if /usr/sbin/visudo -qcf /etc/sudoers; then
        rm -f /etc/sudoers.bak
    else
        echo "Fail to validate remediated /etc/sudoers, reverting to original file."
        mv /etc/sudoers.bak /etc/sudoers
        false
    fi
else
    echo "Skipping remediation, /etc/sudoers failed to validate"
    false
fi
