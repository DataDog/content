#!/bin/bash
# platform = multi_platform_ubuntu
{{% if product == "ubuntu2404" %}}
{{% set loose_mode = "2775" %}}
{{% else %}}
{{% set loose_mode = "2755" %}}
{{% endif %}}

# Precedence dimension: FILE NAME ordering, drop-in sorting AFTER the drop-in
# written by the remediation.
#
# Because z/Z entries are applied to already existing inodes, systemd-tmpfiles
# applies every matching entry and the entry applied last wins. A drop-in that
# sorts after "zzz-systemd-stig.conf" would therefore be applied last and would
# reset the journal directories back to a too permissive mode. The remediation
# neutralizes conflicting journal entries in the other drop-ins.
mkdir -p /etc/tmpfiles.d
cat > /etc/tmpfiles.d/zzzz-late-override.conf <<'EOF'
z /run/log/journal {{{ loose_mode }}} root systemd-journal - -
z /var/log/journal {{{ loose_mode }}} root systemd-journal - -
EOF

mkdir -p /run/log/journal /var/log/journal
chmod {{{ loose_mode }}} /run/log/journal /var/log/journal
