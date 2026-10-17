#!/bin/bash

useradd -m testuser_dot
touch /home/testuser_dot/.bashrc
chmod 0744 /home/testuser_dot/.bashrc
