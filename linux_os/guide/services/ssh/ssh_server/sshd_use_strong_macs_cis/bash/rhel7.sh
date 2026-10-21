# platform = Red Hat Enterprise Linux 7
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# OpenSSH 7.4 rejects a list that removes algorithms from the default
# set, so write the strong MACs that the benchmark gives as its example.
{{{
    bash_sshd_remediation(
        parameter="MACs",
        value="hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512,hmac-sha2-256",
        config_is_distributed=sshd_distributed_config,
        rule_id=rule_id
    )
}}}
