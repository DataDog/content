# platform = Red Hat Enterprise Linux 7
# reboot = false
# strategy = restrict
# complexity = low
# disruption = low

# OpenSSH 7.4 rejects a list that removes algorithms from the default
# set, so write the strong key exchange algorithms that the benchmark
# gives as its example.
{{{
    bash_sshd_remediation(
        parameter="KexAlgorithms",
        value="curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256",
        config_is_distributed=sshd_distributed_config,
        rule_id=rule_id
    )
}}}
