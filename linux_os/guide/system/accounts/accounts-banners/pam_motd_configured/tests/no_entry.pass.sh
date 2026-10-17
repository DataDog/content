#!/bin/bash
# platform = Ubuntu 24.04,Ubuntu 26.04

for f in /etc/pam.d/*; do
    [[ -f "$f" ]] && sed -ri '/pam_motd\.so/d' "$f"
done
