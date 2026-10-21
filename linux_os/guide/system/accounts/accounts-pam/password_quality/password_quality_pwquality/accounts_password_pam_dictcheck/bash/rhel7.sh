# platform = Red Hat Enterprise Linux 7
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# libpwquality 1.2.3 always runs the dictionary check and has no dictcheck
# option: it stops reading pwquality.conf at the first option it does not know.
sed -i --follow-symlinks 's/^\s*dictcheck\b/# &/' "{{{ pwquality_path }}}"
{{{ bash_remove_pam_module_option_configuration('/etc/pam.d/system-auth', 'password', '', 'pam_pwquality.so', 'dictcheck') }}}
{{{ bash_remove_pam_module_option_configuration('/etc/pam.d/password-auth', 'password', '', 'pam_pwquality.so', 'dictcheck') }}}
