# platform = multi_platform_ubuntu
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

{{{
    bash_sshd_remediation(
        parameter="KexAlgorithms",
        value="-" ~ sshd_cis_weak_kex(),
        config_is_distributed=sshd_distributed_config,
        rule_id=rule_id
    )
}}}
