#!/usr/bin/env bash

#Creating python virtual environmant
#Install require libs

#Script takes a value: -n project_name

#Example: 
#venv-python35-prepair.sh -n project

#Require:
#installed python35

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
#Create virtual python

venv_path="/home/hotdog/$APP_NAME/.venv_$APP_NAME"

rm -rf $venv_path && mkdir $venv_path
python3.5 -m venv $venv_path
source $venv_path/bin/activate


#----------------------------------------------------------------------------
#Install required pkgs

pip install django==2.0.2
pip install psycopg2==2.7.1
pip install uwsgi

pip3 install python3-memcached
