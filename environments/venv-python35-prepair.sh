#!/usr/bin/env bash

#Creating python virtual environmant
#Install require libs

#Script takes a value: -n project_name, -v env_name
#As default value use pattern: .venv_[a-z]*

#Example: 
#venv-python35-prepair.sh -n project -v .venv_projectname

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
#Create virtual python

venv_path="/home/hotdog/$APP_NAME/$VENV_FOLDER"

rm -rf $venv_path && mkdir $venv_path
python3.5 -m venv $venv_path
source $venv_path/bin/activate


#----------------------------------------------------------------------------
#Install required pkgs

pip install django==1.9
pip install psycopg2==2.7.1
pip install gunicorn

pip3 install python3-memcached
