#!/usr/bin/env bash

#Script create basic settings of uwsgi service

#Example:
#uwsgi-basic-config.sh

#Require:
#installed python-uwsgi

#----------------------------------------------------------------------------
#Prepair uwsgi

mkdir -p /etc/uwsgi/applications
touch /etc/uwsgi/main_uwsgi.ini
cat >> /etc/uwsgi/main_uwsgi.ini << EOF
[uwsgi]
main_uwsgi = /etc/uwsgi/applications
uid = hotdog
gid = hotdog
master = true
enable-threads = true

EOF
