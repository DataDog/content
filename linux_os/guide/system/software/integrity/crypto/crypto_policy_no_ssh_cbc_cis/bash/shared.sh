# platform = multi_platform_all
# reboot = true
# strategy = configure
# complexity = low
# disruption = low

current_pol=/etc/crypto-policies/state/CURRENT.pol
ssh_scope='^[[:space:]]*cipher@(lib|open)ssh(-server|-client)?[[:space:]]*='

# cipher@openssh covers both the OpenSSH client and server, and an SSH
# back-end that no SSH cipher line covers uses the global cipher line.
if [ ! -f "$current_pol" ] ||
    grep -Eiq "${ssh_scope}[^#]*-CBC\b" "$current_pol" ||
    { grep -Eiq '^[[:space:]]*cipher[[:space:]]*=[^#]*-CBC\b' "$current_pol" &&
        { ! grep -Eiq '^[[:space:]]*cipher@libssh[[:space:]]*=' "$current_pol" ||
            ! grep -Eiq '^[[:space:]]*cipher@openssh(-client)?[[:space:]]*=' "$current_pol" ||
            ! grep -Eiq '^[[:space:]]*cipher@openssh(-server)?[[:space:]]*=' "$current_pol"; }; }; then
    module=/etc/crypto-policies/policies/modules/NO-SSHCBC.pmod
    # End the module with a newline, so that the line appended below starts
    # a line of its own.
    [ -z "$(tail -c 1 "$module" 2>/dev/null)" ] || echo >>"$module"
    grep -qsxF -- 'cipher@SSH = -*-CBC' "$module" || echo 'cipher@SSH = -*-CBC' >>"$module"
    chmod 0644 "$module"
    # Apply NO-SSHCBC last, after any subpolicy that enables what it disables.
    crypto_policy=$(update-crypto-policies --show | sed -e 's/$/:/' -e 's/:NO-SSHCBC:/:/g' -e 's/:$//')
    update-crypto-policies --set "$crypto_policy:NO-SSHCBC"
fi
