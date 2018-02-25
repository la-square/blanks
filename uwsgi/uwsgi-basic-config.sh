#!/usr/bin/env bash

#Script create basic settings of uwsgi service

#Script takes a value: app_name

#Example:
#uwsgi-basic-config.sh

#Require:
#installed python-uwsgi -n project_name

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
#Prepair uwsgi config

printf "${CYAN}Init uwsgi main config...${NC}\n"

mkdir -p /etc/uwsgi/vassals_$APP_NAME      2>&1 > /dev/null
rm -rf /etc/uwsgi/main_uwsgi.ini

touch /etc/uwsgi/main_uwsgi.ini
cat >> /etc/uwsgi/main_uwsgi_$APP_NAME.ini << EOF
[uwsgi]
main_uwsgi = /etc/uwsgi/vassals_$APP_NAME
pidfile=/run/.uwsgi_$APP_NAME.pid
uid = hotdog
gid = hotdog
master = true
enable-threads = true
buffer-size = 32768

EOF


#----------------------------------------------------------------------------
#Prepair uwsgi daemon

printf "${CYAN}Init uwsgi service...${NC}\n"

rm -rf /etc/systemd/system/uwsgi_$APP_NAME.service
touch /etc/systemd/system/uwsgi_$APP_NAME.service
cat >> /etc/systemd/system/uwsgi_$APP_NAME.service<< EOF
[Unit]
Description=uWSGI
After=syslog.target

[Service]
ExecStart=/home/hotdog/$APP_NAME/.venv_$APP_NAME/bin/uwsgi --ini /etc/uwsgi/main_uwsgi_$APP_NAME.ini \
--emperor /etc/uwsgi/vassals_$APP_NAME

RuntimeDirectory=uwsgi
Restart=always
KillSignal=SIGQUIT
Type=notify
StandardError=syslog
NotifyAccess=all

[Install]
WantedBy=multi-user.target

EOF

#----------------------------------------------------------------------------
#Run uwsgi
chown -R hotdog:hotdog /home/hotdog

systemctl daemon-reload
systemctl restart uwsgi_$APP_NAME.service 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
	err=$(cat /dev/shm/c1stderr)
	printf "${RED}$err${NC}\n"
else 
	printf "uwsgi.service       ${GREEN}active${NC}\n"
fi

