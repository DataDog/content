# platform = multi_platform_ubuntu
#!/bin/bash

{{{ bash_package_install("aide") }}}
{{%- if product == "ubuntu2004" %}}

# aide-common 0.16 of Ubuntu 20.04 runs its daily check from cron and
# ships no dailyaidecheck units.
if [ ! -e /etc/systemd/system/dailyaidecheck.service ] && [ ! -e /lib/systemd/system/dailyaidecheck.service ]; then
    cat > /etc/systemd/system/dailyaidecheck.service <<EOF
[Unit]
Description=Daily AIDE check

[Service]
Type=oneshot
ExecStart={{{ aide_bin_path }}} --check
EOF
    chmod 0644 /etc/systemd/system/dailyaidecheck.service
fi
if [ ! -e /etc/systemd/system/dailyaidecheck.timer ] && [ ! -e /lib/systemd/system/dailyaidecheck.timer ]; then
    cat > /etc/systemd/system/dailyaidecheck.timer <<EOF
[Unit]
Description=Daily AIDE check

[Timer]
OnCalendar=*-*-* 05:00:00

[Install]
WantedBy=timers.target
EOF
    chmod 0644 /etc/systemd/system/dailyaidecheck.timer
fi

systemctl daemon-reload
systemctl unmask dailyaidecheck.service dailyaidecheck.timer
systemctl enable dailyaidecheck.timer
if [[ $(systemctl is-system-running) != "offline" ]]; then
    systemctl start dailyaidecheck.timer
fi
{{%- else %}}

systemctl unmask dailyaidecheck.service
systemctl unmask dailyaidecheck.timer
systemctl --now enable dailyaidecheck.timer
{{%- endif %}}
