# platform = multi_platform_all
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{ bash_sudo_remove_config("visiblepw", 'visiblepw\\b', prefix='[ \\t]*Defaults\\b[^#\\n]*[ \\t,]') }}}
