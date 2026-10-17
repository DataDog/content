#!/bin/bash
# variables = var_password_hashing_algorithm_pam=sha512|yescrypt

# Test that a value outside the multi-value variable fails
cp libuser.conf /etc/
sed -i "s/crypt_style = sha512/crypt_style = sha256/" /etc/libuser.conf
