#!/bin/bash
# variables = var_accounts_user_umask=027

if grep -q "^UMASK" {{{ login_defs_path }}}; then
	sed -i "s/^UMASK.*/UMASK 0027/" {{{ login_defs_path }}}
else
	echo "UMASK 0027" >> {{{ login_defs_path }}}
fi
