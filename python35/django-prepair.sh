#!/usr/bin/env bash

#Creating python virtual environmant
#Install require libs

#Script takes a value: -n project_name

#Example: 
#venv-python35-prepair.sh -n project

#Require:
#installed python35

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
	printf "${RED}django-prepair.sh was skipped.${NC}\n"
	exit 1
fi


#----------------------------------------------------------------------------
#Create virtual python

printf "${CYAN}Start init python venv...${NC}\n"

venv_path="/home/hotdog/$APP_NAME/.venv_$APP_NAME"

rm -rf $venv_path && mkdir $venv_path
python3.5 -m venv $venv_path
source $venv_path/bin/activate

chown -R hotdog:hotdog /home/hotdog
printf "project venv        ${GREEN}ok${NC}\n"

#----------------------------------------------------------------------------
#Install required pkgs

printf "${CYAN}Installing python pkgs...${NC}\n"

pip install django==2.0.2    2>&1 > /dev/null 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
	err=$(cat /dev/shm/c1stderr)
	printf "${RED}$err${NC}\n"
else 
	printf "django...           ${GREEN}ok${NC}\n"
fi
pip install psycopg2==2.7.1 2>&1 > /dev/null 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
	err=$(cat /dev/shm/c1stderr)
	printf "${RED}$err${NC}\n"
else 
	printf "psycopg2...         ${GREEN}ok${NC}\n"
fi
pip install uwsgi 2>&1 > /dev/null 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
	err=$(cat /dev/shm/c1stderr)
	printf "${RED}$err${NC}\n"
else 
	printf "uwsgi...            ${GREEN}ok${NC}\n"
fi
pip3 install python3-memcached 2>&1 > /dev/null 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
	err=$(cat /dev/shm/c1stderr)
	printf "${RED}$err${NC}\n"
else 
	printf "memcached...        ${GREEN}ok${NC}\n"
fi
