# rhel7_cis_pam_files writes /etc/pam.d/system-auth-ac and password-auth-ac
# in the layout of the CIS Red Hat Enterprise Linux 7 Benchmark v4.0.0 and
# links system-auth and password-auth to them, as authconfig does. The
# arguments of the pam_faillock, pam_pwquality, pam_pwhistory and pam_unix
# password lines come from FAILLOCK_ARGS, PWQUALITY_ARGS, PWHISTORY_ARGS and
# UNIX_ARGS, and FAILLOCK_AUTHFAIL_CONTROL gives the control of the authfail
# line.
rhel7_cis_pam_files() {
    local f
    for f in system-auth password-auth; do
        rm -f "/etc/pam.d/$f" "/etc/pam.d/$f-ac"
        cat >"/etc/pam.d/$f-ac" <<EOF
#%PAM-1.0
auth        required      pam_env.so
auth        required      pam_faillock.so preauth silent ${FAILLOCK_ARGS-audit deny=5 unlock_time=900 even_deny_root}
auth        sufficient    pam_unix.so try_first_pass
auth        ${FAILLOCK_AUTHFAIL_CONTROL-[default=die]} pam_faillock.so authfail ${FAILLOCK_ARGS-audit deny=5 unlock_time=900 even_deny_root}
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so

account     required      pam_faillock.so
account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so

password    requisite     pam_pwquality.so ${PWQUALITY_ARGS-try_first_pass local_users_only retry=3}
password    required      pam_pwhistory.so ${PWHISTORY_ARGS-remember=24 enforce_for_root try_first_pass use_authtok}
password    sufficient    pam_unix.so ${UNIX_ARGS-sha512 shadow try_first_pass use_authtok}
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session    optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
        ln -s "$f-ac" "/etc/pam.d/$f"
    done
}
