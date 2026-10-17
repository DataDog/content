#!/bin/bash
# platform = Ubuntu 24.04,Ubuntu 26.04

for f in /etc/pam.d/*; do
    [[ -f "$f" ]] && sed -ri '/pam_motd\.so/d' "$f"
done
printf 'Authorized use only.\n' > /etc/motd.cac
printf 'Authorized use only.\n' > /etc/motd.cac.fallback
chown root:root /etc/motd.cac /etc/motd.cac.fallback
chmod 0644 /etc/motd.cac
chmod 0666 /etc/motd.cac.fallback
# pam_motd shows the second file when the first is missing.
echo 'session optional pam_motd.so motd=/etc/motd.cac:/etc/motd.cac.fallback' >> /etc/pam.d/sshd
