#!/bin/bash
# variables = var_firewall_accept_other_utility=true

{{{ bash_package_remove(PACKAGE) }}}
{{{ bash_package_install(OTHERS[0].package) }}}
mkdir -p /etc/systemd/system/multi-user.target.wants
ln -sf /usr/lib/systemd/system/{{{ OTHERS[0].services[0] }}}.service \
    /etc/systemd/system/multi-user.target.wants/{{{ OTHERS[0].services[0] }}}.service
