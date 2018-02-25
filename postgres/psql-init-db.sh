#!/usr/bin/env bash

#Script init database, user and add grant to database

#Script takes a value: db_name, db_user, db_password, force (additional arg)
#use 4th arg force for re-init database with drop current version

#Example: 
#psql-init-db.sh -n project_db -u user_db -p 12345
#psql-init-db.sh -n project_db -u user_db -p 12345 -f force

#Require:
#installed postgresql

#----------------------------------------------------------------------------
#Check options

while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
		-n|--name)
		DB_NAME=$2
		shift ;;
		-u|--user)
		DB_USER=$2
		shift ;;
		-p|--pass)
		DB_PASS=$2
		shift ;;
		-f|--force)
		IS_FORCE=$2
		shift ;;
	esac
	shift
done

if [[ $DB_NAME = "" ]]; then
	printf "${RED}ERR: forgot DB_NAME attr${NC}\n"
	printf "${RED}psql-init-db.sh was skipped.${NC}\n"
	exit 1
fi

if [[ $DB_USER = "" ]]; then
	printf "${RED}ERR: forgot DB_USER attr${NC}\n"
	printf "${RED}psql-init-db.sh was skipped.${NC}\n"
	exit 1
fi

if [[ $DB_PASS = "" ]]; then
	printf "${RED}ERR: forgot DB_PASS attr${NC}\n"
	printf "${RED}psql-init-db.sh was skipped.${NC}\n"
	exit 1
fi

if [[ $IS_FORCE = "force" ]]; then
	printf "${CYAN}Use force option...${NC}\n"
    sudo -u postgres psql postgres -c "DROP DATABASE ${DB_NAME};" 2>&1 > /dev/null 2>/dev/shm/c1stderr
    if [ "$?" -ne "0" ]; then
		err=$(cat /dev/shm/c1stderr)
		printf "${RED}$err${NC}\n"
	else 
		printf "Drop db...          ${GREEN}ok${NC}\n"
	fi
    sudo -u postgres psql postgres -c "DROP USER ${DB_USER};"     2>&1 > /dev/null 2>/dev/shm/c1stderr
    if [ "$?" -ne "0" ]; then
		err=$(cat /dev/shm/c1stderr)
		printf "${RED}$err${NC}\n"
	else 
		printf "Drop user...        ${GREEN}ok${NC}\n"
	fi
fi

#----------------------------------------------------------------------------
#DB operations
chown -R hotdog:hotdog /home/hotdog

sudo -u postgres psql postgres -c "CREATE DATABASE ${DB_NAME};" 2>&1 > /dev/null 2>/dev/null
sudo -u postgres psql postgres -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';" 2>&1 > /dev/null 2>/dev/null
sudo -u postgres psql postgres -c "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};" 2>&1 > /dev/null 2>/dev/null
