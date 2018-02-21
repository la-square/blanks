#!/usr/bin/env bash

#Script deploy basic web-application, implements blanks deploy and blanks-applications

#--------------------------------------------->
#SETTINGS
#--------------------------------------------->

project_name="enter_project_name"
host="enter_hostname"
db_passwd="enter_dbpass"

git_user="username"
git_mail="mail"
git_repository="repository"

#add blank components for deploing
components=(engine)


#--------------------------------------------->
#DEPLOY
#--------------------------------------------->
django_path="/home/hotdog/$project_name/djapp"
states_path="/root/blanks-deploy"
components_path="/root/blanks-applications"

git clone git@github.com:la-square/blanks-deploy.git


#----->
#deploy system pkgs
$states_path/system/centOS7-installer.sh 	-n $project_name

$states_path/python35/django-prepair.sh     -n $project_name
$states_path/postgres/psql-init-db.sh       -n db_$project_name 	-u hotdog 	-p $db_passwd


#----->
#init project
git clone git@github.com:la-square/blanks-applications.git

for app in ${components[*]}
do
	for entry in $components_path/$app/*
	do
		rm -rf $django_path/$entry
	done
	cp -r $components_path/$app/* $django_path/

	if [[ $app = "engine" ]]; then
		/usr/bin/bash $django_path/engine/component_deploy.sh $project_name $host db_$project_name hotdog $db_passwd
	fi

done


#----->
#init uwsgi
$states_path/uwsgi/uwsgi-basic-config.sh 	-n $project_name
$states_path/uwsgi/uwsgi-app-config.sh 		-n $project_name


#----->
#init nginx
$states_path/nginx/nginx-basic-config.sh
$states_path/nginx/nginx-http-server.sh     -n $project_name     -h $host


#----->
#remove artifacts
rm -rf $states_path
rm -rf $components_path

#----->
#clone deploy-script
mkdir /home/hotdog/$project_name/djapp/common
cp /root/basic-deploy.sh /home/hotdog/$project_name/djapp/common/installer.sh


#----->
#init git repository

cd $django_path
git init

if [[ $git_user != "username" ]]; then
	git config --global user.name "$git_user"
else
	echo "WARN: forgot input git username"
	exit 1
fi 

if [[ $git_mail != "mail" ]]; then
	git config --global user.email $git_mail
else
	echo "WARN: forgot input git user mail"
	exit 1
fi 

if [[ $git_repository != "repository" ]]; then
	git remote rename origin upstream
	git remote add origin $git_repository
else
	echo "WARN: forgot input git repository"
	exit 1
fi
