#!/bin/bash
# platform = multi_platform_all
# check-import = stdout

{{% if product == "rhel7" -%}}
{{{ sshd_algorithms_not_offered("macs", sshd_cis_weak_macs(), sshd_cis_weak_macs(amzn2=true)) }}}
{{%- else -%}}
{{{ sshd_algorithms_not_offered("macs", sshd_cis_weak_macs()) }}}
{{%- endif %}}
