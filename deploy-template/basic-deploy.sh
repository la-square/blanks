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

git clone git@github.com:la-square/blanks-deploy.git --quiet


#----->
#deploy system pkgs
$states_path/system/centOS7-installer.sh 	-n $project_name

$states_path/python35/django-prepair.sh     -n $project_name
$states_path/postgres/psql-init-db.sh       -n db_$project_name 	-u hotdog 	-p $db_passwd


#----->
#init project
git clone git@github.com:la-square/blanks-applications.git --quiet

for app in ${components[*]}
do
	printf "prepair $app component\n"
	for entry in $components_path/$app/*
	do
		rm -rf $django_path/$entry
	done
	cp -r $components_path/$app/* $django_path/

	if [[ $app = "engine" ]]; then
		/usr/bin/bash $django_path/engine/component_deploy.sh $project_name $host db_$project_name hotdog $db_passwd
	fi
	printf "OK.\n"
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
#git init
$states_path/init_git/initialize_git.sh     -u $git_user  -m $git_mail -r $git_repository -d $django_path

#----->
#remove artifacts
rm -rf $states_path
rm -rf $components_path

#----->
#clone deploy-script
mkdir /home/hotdog/$project_name/djapp/common > /dev/null 2>&1
cp /root/basic-deploy.sh /home/hotdog/$project_name/djapp/common/installer.sh
