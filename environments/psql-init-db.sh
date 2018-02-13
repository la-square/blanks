#!/usr/bin/env bash

#Script init database, user and add grant to database

#Script takes a value: db_name, db_user, db_password, force (additional arg)
#use 4th arg force for re-init database with drop current version

#Example: 
#psql-init-db.sh project_db user_db 12345
#psql-init-db.sh project_db user_db 12345 force

DB_NAME=$1
DB_USER=$2
DB_PASS=$3

IS_FORCE=$4

if [[ $IS_FORCE = "force" ]]; then
    sudo -u postgres psql postgres -c "DROP DATABASE ${DB_NAME};"
    sudo -u postgres psql postgres -c "DROP USER ${DB_USER};"
fi

sudo -u postgres psql postgres -c "CREATE DATABASE ${DB_NAME};"
sudo -u postgres psql postgres -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';"
sudo -u postgres psql postgres -c "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};"
