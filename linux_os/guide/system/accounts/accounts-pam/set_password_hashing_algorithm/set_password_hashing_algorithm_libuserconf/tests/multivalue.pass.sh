#!/bin/bash
# variables = var_password_hashing_algorithm_pam=sha512|yescrypt

# Test that having the second value in the multi-value variable passes
cp libuser.conf /etc/
sed -i "s/crypt_style = sha512/crypt_style = yescrypt/" /etc/libuser.conf
