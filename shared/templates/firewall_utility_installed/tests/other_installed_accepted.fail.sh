#!/bin/bash
# variables = var_firewall_accept_other_utility=true

{{{ bash_package_remove(PACKAGE) }}}
{{{ bash_package_install(OTHERS[0].package) }}}
rm -f /etc/systemd/system/*.wants/{{{ OTHERS[0].services[0] }}}.service
