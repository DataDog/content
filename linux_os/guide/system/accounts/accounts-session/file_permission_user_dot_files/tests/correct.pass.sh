#!/bin/bash

useradd -m testuser_dot
for f in .bashrc .profile .bash_logout; do
    touch /home/testuser_dot/$f
    chmod 0644 /home/testuser_dot/$f
done
