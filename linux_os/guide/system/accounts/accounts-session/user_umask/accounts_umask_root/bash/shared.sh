# platform = multi_platform_all

{{%- if product == "ubuntu2004" %}}

for file in /root/.bash_profile /root/.bashrc /etc/login.defs; do
    [ -f "$file" ] || continue
    while IFS=: read -r line value; do
        if [[ "$value" =~ ^[0-7]{3,4}$ ]] && (( (8#$value & 8#027) == 8#027 )); then
            continue
        fi
        sed -i -E "${line}s/^(\s*umask\s+)[^[:space:]#;]+/\10027/I" "$file"
    done < <(grep -nPio '^\h*umask\h+\K[^\s#;]+' "$file")
done
{{%- else %}}

{{% if product == "rhel7" -%}}
for file in /root/.bash_profile /root/.bashrc; do
{{%- else -%}}
for file in /root/.bashrc /root/.profile; do
{{%- endif %}}
    if [ -f "$file" ]; then
        sed -i -E -e "s/^([^#]*\bumask)[[:space:]]+[[:digit:]]+/\1 0027/g" "$file"
    fi
done
{{%- endif %}}
