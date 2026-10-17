#!/bin/bash
# platform = multi_platform_all
# check-import = stdout

{{{ sshd_algorithms_not_offered("macs", sshd_cis_weak_macs()) }}}
