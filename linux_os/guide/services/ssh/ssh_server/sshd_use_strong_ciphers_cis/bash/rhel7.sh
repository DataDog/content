# platform = Red Hat Enterprise Linux 7
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# OpenSSH 7.4 rejects a list that removes algorithms from the default
# set, so write the strong ciphers that the benchmark gives as its
# example.
{{{
    bash_sshd_remediation(
        parameter="Ciphers",
        value="chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr",
        config_is_distributed=sshd_distributed_config,
        rule_id=rule_id
    )
}}}
