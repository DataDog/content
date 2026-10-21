# platform = multi_platform_ubuntu
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

os_id=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | sed -e 's/"//g')
pattern='(\\v|\\r|\\m|\\s'
if [[ -n "$os_id" ]]; then
    pattern="$pattern|\\b$os_id\\b"
fi
pattern="$pattern)"

{{% if product == "ubuntu2004" -%}}
for motd_file in /etc/motd /etc/motd.d/*; do
{{%- else -%}}
for motd_file in /etc/motd /run/motd /usr/lib/motd /etc/motd.d/* /run/motd.d/* /usr/lib/motd.d/* /etc/update-motd.d/*; do
{{%- endif %}}
    if [[ -f "$motd_file" ]] && grep -Psqi -- "$pattern" "$motd_file"; then
        rm -f "$motd_file"
    fi
done
