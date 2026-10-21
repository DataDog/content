# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = medium

readarray -t systemaccounts < <(awk -F: \
  '($3 < {{{ uid_min }}} && $3 != root && $3 != halt && $3 != sync && $3 != shutdown \
  && $3 != nfsnobody) { print $1 }' /etc/passwd)

for systemaccount in "${systemaccounts[@]}"; do
    usermod -L "$systemaccount"
done
{{%- if product == "rhel7" %}}

readarray -t nologinaccounts < <(awk -F: '($1 != "root" && $7 ~ /nologin/) { print $1 }' /etc/passwd)
for nologinaccount in "${nologinaccounts[@]}"; do
    usermod -L "$nologinaccount"
done
{{%- endif %}}
