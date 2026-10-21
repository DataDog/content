# platform = Red Hat Enterprise Linux 7
# reboot = false
# strategy = patch
# complexity = low
# disruption = low

if rpm -q --quiet pam; then
    yum -y update pam
else
    yum -y install pam
fi
