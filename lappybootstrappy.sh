#!/usr/bin/env bash

# A wrapper around the main script to run this as the adminsitrative user.
LBS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo -n "Admin username:"
read ADMIN
su -l ${ADMIN} -c "$LBS_DIR/includes/main.sh `whoami`"