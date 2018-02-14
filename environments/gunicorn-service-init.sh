#!/usr/bin/env bash

#Script init gunicorn service for application.

#Script takes a value: app_name, venv_name

#Example: 
#gunicorn-service-init.sh -n app_name -v .venv_name

#Require:
#installed gunicorn service

#----------------------------------------------------------------------------
#Check options

while [[ $# -gt 1 ]]
do
    key="$1"
    case $key in
        -n|--name)
        APP_NAME=$2
        shift ;;
        -v|--venv)
        VENV_FOLDER=$2
        shift ;;
    esac
    shift
done

if [[ $APP_NAME = "" ]]; then
	echo "ERR: forgot APP_NAME attr."
	exit 1
fi

if [[ $VENV_FOLDER = "" ]]; then
	echo "ERR: forgot VENV_FOLDER attr."
	exit 1
fi


#----------------------------------------------------------------------------
#Init application service

SERVICE_NAME="$APP_NAME.service"

rm -rf /etc/systemd/system/$SERVICE_NAME
touch /etc/systemd/system/$SERVICE_NAME


#----------------------------------------------------------------------------
#Configure gunicorn settings

chmod 0777 /etc/systemd/system/$SERVICE_NAME
cat >> /etc/systemd/system/$SERVICE_NAME << EOF
[Unit]
Description=$APP_NAME
After=network.target
[Service]
User=hotdog
Group=hotdog
WorkingDirectory=/home/hotdog/$APP_NAME/djapp
ExecStart=/home/hotdog/$APP_NAME/$VENV_FOLDER/bin/gunicorn --workers 1 --bind \
      unix:/home/hotdog/$APP_NAME/djapp/$APP_NAME.sock configuration.wsgi:application
[Install]
WantedBy=multi-user.target

EOF
chmod 0644 /etc/systemd/system/$SERVICE_NAME


#----------------------------------------------------------------------------
#Run application

systemctl daemon-reload
systemctl start $SERVICE_NAME
