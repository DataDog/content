# platform = multi_platform_debian,multi_platform_ubuntu
# reboot = false
# strategy = disable
# complexity = low
# disruption = low

if LC_ALL=C grep -qiE '^[[:space:]]*enabled[[:space:]]*=' /etc/default/apport 2>/dev/null; then
    LC_ALL=C sed -i --follow-symlinks -E 's/^[[:space:]]*enabled[[:space:]]*=.*/enabled=0/I' /etc/default/apport
else
    {{{ bash_ensure_nl_at_eof("/etc/default/apport") | indent(4) }}}
    printf '%s\n' 'enabled=0' >> /etc/default/apport
fi

SYSTEMCTL_EXEC='/usr/bin/systemctl'
if [[ $("$SYSTEMCTL_EXEC" is-system-running) != "offline" ]]; then
    "$SYSTEMCTL_EXEC" stop 'apport.service'
fi
"$SYSTEMCTL_EXEC" disable 'apport.service'
"$SYSTEMCTL_EXEC" mask 'apport.service'
"$SYSTEMCTL_EXEC" reset-failed 'apport.service' || true
