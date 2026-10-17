# platform = multi_platform_al,multi_platform_ol,multi_platform_rhel,multi_platform_sle,multi_platform_slmicro,multi_platform_ubuntu,multi_platform_almalinux,multi_platform_debian,multi_platform_fedora
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_package_install("aide") }}}

{{% set audit_dirs = aide_audit_dirs().split() -%}}
{{% if audit_dirs | length == 1 -%}}
{{% for file in aide_audit_binaries %}}
if grep -i -E '^.*(/usr)?/sbin/{{{file}}}.*$' {{{ aide_conf_path }}}; then
sed -i -r "s#.*(/usr)?/sbin/{{{file}}}.*#{{{ audit_dirs[0] }}}/{{{file}}} {{{ aide_string() }}}#" {{{ aide_conf_path }}}
else
echo "{{{ audit_dirs[0] }}}/{{{ file }}} {{{ aide_string() }}}" >> {{{ aide_conf_path }}}
fi
{{% endfor %}}
{{%- else %}}
for tool in {{{ aide_audit_binaries | join(" ") }}}; do
    for dir in {{{ audit_dirs | join(" ") }}}; do
        line="$dir/$tool {{{ aide_string() }}}"
        if grep -q -E "^$dir/$tool([[:space:]]|\$)" {{{ aide_conf_path }}}; then
            sed -i -r "s#^$dir/$tool([[:space:]].*)?\$#$line#" {{{ aide_conf_path }}}
        else
            echo "$line" >> {{{ aide_conf_path }}}
        fi
    done
done
{{%- endif %}}
