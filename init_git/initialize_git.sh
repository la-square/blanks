#!/usr/bin/env bash

#Script init git repository inti djapp folder and make firs commit.

#Script takes a values: git_user, git_user_mail, git_repo_name, app_dir

#Example: 
#psql-init-db.sh -u git_user -m git_user_mail -r git_repo_name -d app_dir

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
		-u|--user)
		GIT_USER=$2
		shift ;;
		-m|--mail)
		USER_MAIL=$2
		shift ;;
		-r|--repo)
		GIT_REPO=$2
		shift ;;
		-d|--dir)
		APP_DIR=$2
		shift ;;
	esac
	shift
done

if [[ $GIT_USER = "" ]]; then
	printf "${RED}ERR: forgot GIT_USER attr${NC}\n"
	printf "${RED}system-centOS7-installer.sh was skipped.${NC}\n"
	exit 1
fi

if [[ $USER_MAIL = "" ]]; then
	printf "${RED}ERR: forgot USER_MAIL attr${NC}\n"
	printf "${RED}system-centOS7-installer.sh was skipped.${NC}\n"
	exit 1
fi

if [[ $GIT_REPO = "" ]]; then
	printf "${RED}ERR: forgot GIT_REPO attr${NC}\n"
	printf "${RED}system-centOS7-installer.sh was skipped.${NC}\n"
	exit 1
fi

if [[ $APP_DIR = "" ]]; then
	printf "${RED}ERR: forgot APP_DIR attr${NC}\n"
	printf "${RED}system-centOS7-installer.sh was skipped.${NC}\n"
	exit 1
fi

#----------------------------------------------------------------------------
#Git init

printf "${CYAN}Init git repository...${NC}\n"

cd $APP_DIR
git init --quiet

git remote rename origin upstream --quiet
git remote add origin $GIT_REPO

touch $APP_DIR/.gitignore
cat >> $APP_DIR/.gitignore << EOF
.DS_Store
__pycache__
.pyc
EOF

git add *



