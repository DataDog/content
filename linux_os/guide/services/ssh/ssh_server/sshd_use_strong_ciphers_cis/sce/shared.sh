#!/bin/bash
# platform = multi_platform_all
# check-import = stdout

{{{ sshd_algorithms_not_offered("ciphers", sshd_cis_weak_ciphers()) }}}
