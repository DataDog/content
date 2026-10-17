# platform = multi_platform_all
# reboot = true
# strategy = configure
# complexity = low
# disruption = low
{{%- set exempt_scopes = ["rpm", "dnssec", "smime", "smime-import", "pkcs12", "pkcs12-import", "nss-smime", "nss-smime-import", "nss-pkcs12", "nss-pkcs12-import"] %}}

current_pol=/etc/crypto-policies/state/CURRENT.pol
sha1_in_certs='^[[:space:]]*sha1_in_certs[[:space:]]*='

if [ ! -f "$current_pol" ] ||
    grep -Eiq '^[[:space:]]*(hash|sign)[[:space:]]*=[^#]*SHA-?1\b' "$current_pol" ||
{{%- if product in ["rhel8", "rhel10"] %}}
    ! grep -Eiq "$sha1_in_certs" "$current_pol" ||
{{%- else %}}
    grep -Ei '^[[:space:]]*(hash|sign)@[^[:space:]=]+[[:space:]]*=[^#]*SHA-?1\b' "$current_pol" |
        grep -Eivq '^[[:space:]]*(hash|sign)@({{{ exempt_scopes | join("|") }}})[[:space:]]*=' ||
{{%- endif %}}
    grep -Ei "$sha1_in_certs" "$current_pol" | grep -Evq '=[[:space:]]*0[[:space:]]*(#.*)?$'; then
    module=/etc/crypto-policies/policies/modules/NO-SHA1.pmod
    if [ -f "$module" ] || [ ! -f /usr/share/crypto-policies/policies/modules/NO-SHA1.pmod ]; then
        for line in 'hash = -SHA1' 'sign = -*-SHA1' 'sha1_in_certs = 0'; do
            grep -qsxF -- "$line" "$module" || echo "$line" >>"$module"
        done
        chmod 0644 "$module"
    fi
    # Apply NO-SHA1 last, after any subpolicy that enables what it disables.
    crypto_policy=$(update-crypto-policies --show | sed -e 's/$/:/' -e 's/:NO-SHA1:/:/g' -e 's/:$//')
    update-crypto-policies --set "$crypto_policy:NO-SHA1"
fi
