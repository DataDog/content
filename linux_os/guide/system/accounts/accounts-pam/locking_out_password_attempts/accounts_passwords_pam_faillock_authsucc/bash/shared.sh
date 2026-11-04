# platform = multi_platform_ubuntu
# reboot = false
# strategy = configure
# complexity = low
# disruption = medium

authsucc_conf=cac_faillock_authsucc

cat << EOF > /usr/share/pam-configs/"$authsucc_conf"
Name: Reset the pam_faillock tally upon successful authentication
Default: yes
Priority: 0
Auth-Type: Additional
Auth:
    sufficient                      pam_faillock.so authsucc
EOF
chmod 0644 /usr/share/pam-configs/"$authsucc_conf"

{{{ bash_pam_faillock_enable() }}}

DEBIAN_FRONTEND=noninteractive pam-auth-update --enable "$authsucc_conf"
