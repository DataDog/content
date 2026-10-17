#!/bin/bash
# packages = openssh-server
# platform = multi_platform_ubuntu

# sshd -T stops without /run/sshd, which ssh.service creates when it
# starts, as Ubuntu starts it on the first connection through ssh.socket.
rm -rf /run/sshd
