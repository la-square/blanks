#!/usr/bin/env bash

#Script install additional python libs using pip

#Script takes a value: -n app_name -p pkg_name

#Example: 
#venv-additional-lib.sh -n project -p django-resized

#Require:
#installed python35, init python env on server

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
		-p|--pkg)
		PYTHON_PKG=$2
		shift ;;
	esac
	shift
done

if [[ $APP_NAME = "" ]]; then
	printf "${RED}ERR: forgot APP_NAME attr${NC}\n"
	printf "${RED}additional-libs.sh was skipped.${NC}\n"
	exit 1
fi

if [[ $PYTHON_PKG = "" ]]; then
	printf "${RED}ERR: forgot PYTHON_PKG attr${NC}\n"
	printf "${RED}additional-libs.sh was skipped.${NC}\n"
	exit 1
fi


#----------------------------------------------------------------------------
#Install pkg

venv_path="/home/hotdog/$APP_NAME/.venv_$APP_NAME"

source $venv_path/bin/activate

pip install $PYTHON_PKG 2>&1 > /dev/null 2>/dev/shm/c1stderr
if [ "$?" -ne "0" ]; then
	err=$(cat /dev/shm/c1stderr)
	printf "${RED}$err${NC}\n"
else 
	printf "$PYTHON_PKG...        ${GREEN}ok${NC}\n"
fi
