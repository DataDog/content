# platform = multi_platform_almalinux,multi_platform_rhel
{{{ bash_ensure_pam_module_configuration("/etc/pam.d/system-auth", "password", "sufficient", "pam_unix.so", "use_authtok") }}}
{{{ bash_ensure_pam_module_configuration("/etc/pam.d/password-auth", "password", "sufficient", "pam_unix.so", "use_authtok") }}}
