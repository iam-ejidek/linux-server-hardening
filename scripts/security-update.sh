#!/bin/bash

#===============================
#Name: iam-ejidek
#Date: 2nd Mar, 26
#
#About: Automated Security Update Script.
#===============================


LOG_PATH=/var/log/update_script.log

if [ "$EUID" -ne 0 ]; then
	echo "Please run with sudo"
	exit
fi

apt-get update >> $LOG_PATH
apt-get upgrade -y >> $LOG_PATH
apt-get autoremove -y >> $LOG_PATH

echo "updated date: $date"
