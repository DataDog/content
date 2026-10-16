# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_sudo_replace_defaults_option("timestamp_type=global", 'timestamp_type[[:blank:]]*=[[:blank:]]*"?global\\b"?', "timestamp_type=tty") }}}
