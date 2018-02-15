#!/usr/bin/env bash

#Script init http server config for application

#Script takes a value: app_name

#Example:
#nginx-http-server.sh -n application_name

#Require:
#installed nginx service and confugered nginx.conf

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

#----->
#remove symlinks when rm rf
#proxy set header err
rm -rf /etc/nginx/sites-available/$APP_NAME
touch  /etc/nginx/sites-available/$APP_NAME

cat >> /etc/nginx/sites-available/$APP_NAME << EOF
upstream $APP_NAME {
    server unix:///home/hotdog/$APP_NAME/$APP_NAME.sock;
    keepalive 32;
}

server {
    listen 80;
    server_name www.$APP_NAME, $APP_NAME;
    client_max_body_size 3g;

    error_log  /home/hotdog/error error;
    access_log /home/hotdog/access;

    location / {
        proxy_pass            http://$APP_NAME;
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

ln -s /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/

systemctl daemon-reload
systemctl restart nginx.service
