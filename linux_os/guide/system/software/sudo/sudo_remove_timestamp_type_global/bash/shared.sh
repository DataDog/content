# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_sudo_remove_config("timestamp_type=global", 'timestamp_type[ \\t]*=[ \\t]*"?global\\b', prefix='[ \\t]*Defaults\\b[^#\\n]*[ \\t,]') }}}
