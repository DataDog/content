#!/bin/bash
# packages = audit
{{% if product != "rhel7" or PATH_IS_VARIABLE or not PATH.endswith("/") %}}
# platform = Not Applicable
{{% endif %}}

{{{ setup_augenrules_environment() }}}

echo "-w {{{ PATH.rstrip("/") }}} -p wa -k cis" >> /etc/audit/rules.d/cis.rules
