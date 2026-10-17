#!/bin/bash

useradd -m testuser_dot
touch /home/testuser_dot/.profile
chmod 0664 /home/testuser_dot/.profile
