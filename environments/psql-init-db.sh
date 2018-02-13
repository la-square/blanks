#!/usr/bin/env bash

#Script init database, user and add grant to database

#Script takes a value: db_name, db_user, db_password, force (additional arg)
#use 4th arg force for re-init database with drop current version

#Example: 
#psql-init-db.sh -n project_db -u user_db -p 12345
#psql-init-db.sh -n project_db -u user_db -p 12345 -f force

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
	echo "ERR: forgot DB_NAME attr."
	exit 1
fi

if [[ $DB_USER = "" ]]; then
	echo "ERR: forgot DB_USER attr."
	exit 1
fi

if [[ $DB_PASS = "" ]]; then
	echo "ERR: forgot DB_PASS attr."
	exit 1
fi

if [[ $IS_FORCE = "force" ]]; then
    sudo -u postgres psql postgres -c "DROP DATABASE ${DB_NAME};"
    sudo -u postgres psql postgres -c "DROP USER ${DB_USER};"
fi

#----------------------------------------------------------------------------
#DB operations

sudo -u postgres psql postgres -c "CREATE DATABASE ${DB_NAME};"
sudo -u postgres psql postgres -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';"
sudo -u postgres psql postgres -c "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};"
