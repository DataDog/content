# platform = multi_platform_all
# reboot = true
# strategy = configure
# complexity = low
# disruption = low
{{%- if product in ["rhel8", "rhel10"] %}}
{{%- set weak_mac_regex = "^[[:space:]]*mac[[:space:]]*=[^#]*-128\\b" %}}
{{%- set module_line = "mac = -*-128*" %}}
{{%- else %}}
{{%- set weak_mac_regex = "^[[:space:]]*mac(@[^[:space:]=]+)?[[:space:]]*=[^#]*-64\\b" %}}
{{%- set module_line = "mac = -*-64" %}}
{{%- endif %}}

current_pol=/etc/crypto-policies/state/CURRENT.pol

if [ ! -f "$current_pol" ] || grep -Eiq '{{{ weak_mac_regex }}}' "$current_pol"; then
    module=/etc/crypto-policies/policies/modules/NO-WEAKMAC.pmod
    grep -qsxF -- '{{{ module_line }}}' "$module" || echo '{{{ module_line }}}' >>"$module"
    chmod 0644 "$module"
    # Apply NO-WEAKMAC last, after any subpolicy that enables what it disables.
    crypto_policy=$(update-crypto-policies --show | sed -e 's/$/:/' -e 's/:NO-WEAKMAC:/:/g' -e 's/:$//')
    update-crypto-policies --set "$crypto_policy:NO-WEAKMAC"
fi
