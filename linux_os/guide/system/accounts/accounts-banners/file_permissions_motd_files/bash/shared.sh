# platform = multi_platform_ubuntu
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

for motd_file in /etc/motd /run/motd /usr/lib/motd /etc/motd.d/* /run/motd.d/* /usr/lib/motd.d/* /etc/update-motd.d/*; do
    [[ -f "$motd_file" ]] || continue
    chown root:root "$motd_file"
    chmod u-xs,g-wxs,o-wxt "$motd_file"
done
