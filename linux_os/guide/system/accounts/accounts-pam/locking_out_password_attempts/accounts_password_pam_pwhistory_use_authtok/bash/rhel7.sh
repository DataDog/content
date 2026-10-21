# platform = Red Hat Enterprise Linux 7
# reboot = false
# strategy = configure
# complexity = low
# disruption = low

{{{ bash_pam_pwhistory_enable('/etc/pam.d/system-auth', 'requisite', '^password.*requisite.*pam_pwquality\.so') }}}
{{{ bash_pam_pwhistory_parameter_value('/etc/pam.d/system-auth', 'use_authtok') }}}
{{{ bash_pam_pwhistory_enable('/etc/pam.d/password-auth', 'requisite', '^password.*requisite.*pam_pwquality\.so') }}}
{{{ bash_pam_pwhistory_parameter_value('/etc/pam.d/password-auth', 'use_authtok') }}}
