# platform = multi_platform_all
# complexity = low
# disruption = low
# reboot = false
# strategy = restrict

{{{ bash_instantiate_variables("var_account_disable_post_pw_expiration") }}}
{{#- The CIS RHEL 7 audit also fails an INACTIVE field of -1. #}}
{{%- set negative = " || $7 < 0" if product == "rhel7" else "" %}}

{{% call iterate_over_command_output("i", "awk -v var=\"$var_account_disable_post_pw_expiration\" -F: '(($7 > var || $7 == \"\"" ~ negative ~ ") && $2 ~ /^\$/) {print $1}' /etc/shadow") -%}}
chage --inactive $var_account_disable_post_pw_expiration $i
{{%- endcall %}}
