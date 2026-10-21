#!/bin/bash
# platform = multi_platform_ubuntu
# check-import = stdout

os_id=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | sed -e 's/"//g')
pattern='(\\v|\\r|\\m|\\s'
if [[ -n "$os_id" ]]; then
    pattern="$pattern|\\b$os_id\\b"
fi
pattern="$pattern)"

result=$XCCDF_RESULT_PASS
{{% if product == "ubuntu2004" -%}}
for motd_file in /etc/motd /etc/motd.d/*; do
{{%- else -%}}
for motd_file in /etc/motd /run/motd /usr/lib/motd /etc/motd.d/* /run/motd.d/* /usr/lib/motd.d/* /etc/update-motd.d/*; do
{{%- endif %}}
    [[ -f "$motd_file" ]] || continue
    if grep -Psqi -- "$pattern" "$motd_file"; then
        echo "$motd_file contains operating-system information or a prohibited escape sequence."
        result=$XCCDF_RESULT_FAIL
    fi
done

exit "$result"
