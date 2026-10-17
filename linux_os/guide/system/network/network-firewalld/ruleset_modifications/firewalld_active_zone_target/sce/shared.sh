#!/bin/bash
# platform = multi_platform_rhel,multi_platform_almalinux,multi_platform_fedora,multi_platform_ol
# check-import = stdout

# Every active zone that holds an interface other than lo or a virbr bridge
# must have a target other than ACCEPT, and the same target in the permanent
# configuration as in the running one. At least one such zone must be active.

command -v firewall-cmd >/dev/null 2>&1 || exit "$XCCDF_RESULT_FAIL"

checked=0
while read -r zone; do
    interfaces=$(firewall-cmd --zone="$zone" --list-interfaces)
    if [ -n "$interfaces" ] && ! printf '%s\n' $interfaces | grep -Pqv '^(lo|virbr\S+)$'; then
        continue
    fi
    target=$(firewall-cmd --zone="$zone" --list-all | awk '$1 == "target:" {print tolower($2)}')
    permanent=$(firewall-cmd --permanent --zone="$zone" --get-target | tr '[:upper:]' '[:lower:]')
    if [ -z "$target" ] || [ "$target" = accept ] || [ "$target" != "$permanent" ]; then
        echo "zone $zone: target \"$target\", permanent target \"$permanent\""
        exit "$XCCDF_RESULT_FAIL"
    fi
    checked=$((checked + 1))
done < <(firewall-cmd --get-active-zones 2>/dev/null | awk '$1 !~ /^(interfaces|sources):$/ {print $1}')

if [ "$checked" -eq 0 ]; then
    echo "no active zone holds an interface other than lo or a virbr bridge"
    exit "$XCCDF_RESULT_FAIL"
fi
exit "$XCCDF_RESULT_PASS"
