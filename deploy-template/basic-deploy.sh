#!/usr/bin/env bash

#Script deploy basic web-application, implements blanks deploy and blanks-applications

#--------------------------------------------->
#SETTINGS
#--------------------------------------------->

project_name="enter_project_name"
host="enter_hostname"
db_passwd="enter_dbpass"

#add blank components for deploing
components=(core)


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
