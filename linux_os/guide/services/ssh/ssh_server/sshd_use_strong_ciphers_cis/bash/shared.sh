# platform = multi_platform_ubuntu
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{
    bash_sshd_remediation(
        parameter="Ciphers",
        value="-" ~ sshd_cis_weak_ciphers(),
        config_is_distributed=sshd_distributed_config,
        rule_id=rule_id
    )
}}}
