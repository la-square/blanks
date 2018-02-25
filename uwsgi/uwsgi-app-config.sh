#!/usr/bin/env bash

#Script create uwsgi config for application

#Script takes a value: app_name

#Example:
#uwsgi-app-config.sh -n project_name

#Require:
#installed python-uwsgi, uwsgi-basic-config

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

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
	printf "${RED}ERR: forgot APP_NAME attr${NC}\n"
	printf "${RED}system-centOS7-installer.sh was skipped.${NC}\n"
	exit 1
fi


#----------------------------------------------------------------------------
#Prepair uwsgi

printf "${CYAN}Init project uwsgi config...${NC}\n"

mkdir -p /home/hotdog/$APP_NAME/logs/uwsgi 2>&1 > /dev/null
touch /home/hotdog/$APP_NAME/logs/uwsgi/uwsgi.log

rm -rf /etc/uwsgi/vassals_${APP_NAME}/uwsgi_${APP_NAME}.ini
touch  /etc/uwsgi/vassals_${APP_NAME}/uwsgi_${APP_NAME}.ini
cat >> /etc/uwsgi/vassals_${APP_NAME}/uwsgi_${APP_NAME}.ini << EOF
[uwsgi]
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

printf "uwsgi config...     ${GREEN}ok${NC}\n"

#----------------------------------------------------------------------------
#Run uwsgi
chown -R hotdog:hotdog /home/hotdog

printf "${CYAN}Restart uwsgi service...${NC}\n"

systemctl daemon-reload
systemctl restart uwsgi_$APP_NAME.service 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
	err=$(cat /dev/shm/c1stderr)
	printf "${RED}$err${NC}\n"
else 
	printf "uwsgi.service       ${GREEN}active${NC}\n"
fi
