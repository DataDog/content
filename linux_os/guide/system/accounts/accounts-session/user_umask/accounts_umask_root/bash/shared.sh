# platform = multi_platform_all

{{% if product == "rhel7" -%}}
for file in /root/.bash_profile /root/.bashrc; do
{{%- else -%}}
for file in /root/.bashrc /root/.profile; do
{{%- endif %}}
    if [ -f "$file" ]; then
        sed -i -E -e "s/^([^#]*\bumask)[[:space:]]+[[:digit:]]+/\1 0027/g" "$file"
    fi
done
