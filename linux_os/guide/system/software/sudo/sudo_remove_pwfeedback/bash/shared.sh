# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_sudo_remove_config("pwfeedback", 'pwfeedback\\b', prefix='[ \\t]*Defaults\\b[^#\\n]*[ \\t,]') }}}
