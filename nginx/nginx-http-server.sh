#!/usr/bin/env bash

#Script init http server config for application

#Script takes a value: app_name, hostname

#Example:
#nginx-http-server.sh -n application_name, -h hostname

#Require:
#installed nginx service and confugered nginx.conf

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
        -h|--name)
        HOST_NAME=$2
        shift ;;
    esac
    shift
done

if [[ $APP_NAME = "" ]]; then
    printf "${RED}ERR: forgot APP_NAME attr${NC}\n"
    printf "${RED}system-centOS7-installer.sh was skipped.${NC}\n"
    exit 1
fi

if [[ $HOST_NAME = "" ]]; then
    printf "${RED}ERR: forgot HOST_NAME attr${NC}\n"
    printf "${RED}nginx-http-server.sh was skipped.${NC}\n"
    exit 1
fi

#----->
#remove symlinks when rm rf
#proxy set header err

printf "${CYAN}Init application nginx settings...${NC}\n"

rm -rf /etc/nginx/sites-available/$APP_NAME
touch  /etc/nginx/sites-available/$APP_NAME

mkdir -p /home/hotdog/$APP_NAME/logs/nginx 2>&1 > /dev/null
touch /home/hotdog/$APP_NAME/logs/nginx/error.log
touch /home/hotdog/$APP_NAME/logs/nginx/access.log

cat >> /etc/nginx/sites-available/$APP_NAME << EOF
upstream $APP_NAME {
    server unix:///home/hotdog/$APP_NAME/$APP_NAME.sock;
    keepalive 32;
}

server {
    listen 80;
    server_name www.$HOST_NAME, $HOST_NAME;
    client_max_body_size 3g;
    charset     utf-8;

    error_log  /home/hotdog/$APP_NAME/logs/nginx/error.log error;
    access_log /home/hotdog/$APP_NAME/logs/nginx/access.log;

    location / {
        uwsgi_pass            $APP_NAME;
        include               uwsgi_params;
    }

    location /media {
        root /home/hotdog/$APP_NAME/media;
        add_header Cache-Control public;
        expires 360d;
    }

    location ~ ^/(js|css|img|content|static)/ {
        root  /home/hotdog/$APP_NAME/djapp;
        add_header Cache-Control private;
        expires 360d;
    }

    location = /robots.txt {
        root /home/hotdog/$APP_NAME/djapp;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /home/hotdog/$APP_NAME/djapp;
        internal;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {

    }

}

EOF

ln -s /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/ > /dev/null 2>&1


#----------------------------------------------------------------------------
#Restart daemon
chown -R hotdog:hotdog /home/hotdog

printf "${CYAN}Start nginx...${NC}\n"

systemctl daemon-reload
systemctl restart nginx.service 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
    err=$(cat /dev/shm/c1stderr)
    printf "${RED}$err${NC}\n"
else 
    printf "nginx.service       ${GREEN}active${NC}\n"
fi

