# platform = multi_platform_all
# reboot = true
# strategy = configure
# complexity = low
# disruption = low

current_pol=/etc/crypto-policies/state/CURRENT.pol
ssh_scope='^[[:space:]]*cipher@(lib|open)ssh(-server|-client)?[[:space:]]*='

if [ ! -f "$current_pol" ] ||
    grep -Eiq "${ssh_scope}[^#]*-CBC\b" "$current_pol" ||
    { ! grep -Eiq "$ssh_scope" "$current_pol" &&
        grep -Eiq '^[[:space:]]*cipher[[:space:]]*=[^#]*-CBC\b' "$current_pol"; }; then
    module=/etc/crypto-policies/policies/modules/NO-SSHCBC.pmod
    grep -qsxF -- 'cipher@SSH = -*-CBC' "$module" || echo 'cipher@SSH = -*-CBC' >>"$module"
    chmod 0644 "$module"
    # Apply NO-SSHCBC last, after any subpolicy that enables what it disables.
    crypto_policy=$(update-crypto-policies --show | sed -e 's/$/:/' -e 's/:NO-SSHCBC:/:/g' -e 's/:$//')
    update-crypto-policies --set "$crypto_policy:NO-SSHCBC"
fi
