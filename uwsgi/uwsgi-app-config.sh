#!/usr/bin/env bash

#Script create uwsgi config for application

#Script takes a value: app_name

#Example:
#uwsgi-app-config.sh -n project_name

#Require:
#installed python-uwsgi, uwsgi-basic-config

#----------------------------------------------------------------------------
#Check options

while [[ $# -gt 1 ]]
do
    key="$1"
    case $key in
        -n|--name)
        APP_NAME=$2
        shift ;;
    esac
    shift
done

if [[ $APP_NAME = "" ]]; then
    echo "ERR: forgot APP_NAME attr."
    exit 1
fi


#----------------------------------------------------------------------------
#Prepair uwsgi

mkdir /home/hotdog/$APP_NAME/logs/uwsgi
touch /home/hotdog/$APP_NAME/logs/uwsgi/uwsgi.log

rm -rf /etc/uwsgi/vassals/uwsgi_${APP_NAME}.ini
touch  /etc/uwsgi/vassals/uwsgi_${APP_NAME}.ini
cat >> /etc/uwsgi/vassals/uwsgi_${APP_NAME}.ini << EOF
[uwsgi]
pidfile=/run/${APP_NAME}_uwsgi.pid
socket = /home/hotdog/$APP_NAME/${APP_NAME}.sock
chmod-socket = 666

processes = 1
threads = 2
offload-threads = 2

virtualenv = /home/hotdog/$APP_NAME/.venv_$APP_NAME/
chdir = /home/hotdog/$APP_NAME/djapp
wsgi-file = /home/hotdog/$APP_NAME/djapp/wsgi.py
vacuum = true

logto = /home/hotdog/$APP_NAME/logs/uwsgi/uwsgi.log
logfile-chown = true

ignore-sigpipe = true
ignore-write-errors = true
disable-write-exception = true

EOF

#----------------------------------------------------------------------------
#Run uwsgi
chown -R hotdog:hotdog /home/hotdog

systemctl daemon-reload
systemctl restart uwsgi.service

