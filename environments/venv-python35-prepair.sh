#!/usr/bin/env bash

#Creating python virtual environmant
#Install require libs

#Script takes a value: env_name
#As default value use pattern: venv_[a-z]*

#Example: 
#venv-python35-prepair.sh venv_projectname

VENV_FOLDER=$1

if [[ $VENV_FOLDER = "" ]]; then
    exit 1
fi

venv_path="/home/hotdog/$VENV_FOLDER"

rm -rf $venv_path && mkdir $venv_path
python3.5 -m venv $venv_path
source $venv_path/bin/activate

pip install django==1.9
pip install psycopg2==2.7.1
pip install gunicorn

pip3 install python3-memcached
