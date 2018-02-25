#!/usr/bin/env bash


#Installing a set of utilities for the django web-server
# - system user
# - systemd
# - sudo 
# - nginx
# - postgres
# - python35
# - custom vim

#Script takes a value: -n project_name

#Example: 
#system-centOS7-installer -n burokrat

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
	echo "ERR: forgot APP_NAME attr."
	exit 1
fi

#----------------------------------------------------------------------------
#Package install

echo "Start install system packages..."

yes Y | yum install epel-release 				2>&1 > /dev/null
yes Y | yum update 								2>&1 > /dev/null

yes Y | yum install gcc 						2>&1 > /dev/null
yes Y | yum install sudo 						2>&1 > /dev/null
yes Y | yum install systemd 					2>&1 > /dev/null
yes Y | yum install memcached 					2>&1 > /dev/null

yes Y | yum install postgresql-server 			2>&1 > /dev/null
yes Y | yum install postgresql-devel			2>&1 > /dev/null
yes Y | yum install postgresql-contrib 			2>&1 > /dev/null

yes Y | yum -y install https://centos7.iuscommunity.org/ius-release.rpm 2>&1 > /dev/null
yes Y | yum -y install python35u 				2>&1 > /dev/null
yes Y | yum -y install python35u-pip			2>&1 > /dev/null
yes Y | yum -y install python35u-devel.x86_64	2>&1 > /dev/null

yum -y install nginx 							2>&1 > /dev/null

echo "done"


#----------------------------------------------------------------------------
#Prapair work environment

echo "Create user, project folders, configure vim..."

#-> vim configs
wget -O ~/.vimrc http://dumpz.org/25712/nixtext/ 	2>&1 > /dev/null
update-alternatives --set editor /usr/bin/vim.basic 2>&1 > /dev/null

#-> prepair user
useradd -m hotdog -s /bin/bash						2>&1 > /dev/null

mkdir -p /home/hotdog/$APP_NAME/djapp 				2>&1 > /dev/null
mkdir -p /home/hotdog/$APP_NAME/media				2>&1 > /dev/null
mkdir -p /home/hotdog/$APP_NAME/logs				2>&1 > /dev/null

chown -R hotdog:hotdog /home/hotdog 				2>&1 > /dev/null

echo "done"


#----------------------------------------------------------------------------
#Prapair system services

echo "Start init postgres..."

#-> postgres
sed -i "s/ident/md5/g" /var/lib/pgsql/data/pg_hba.conf
postgresql-setup initdb 2>&1 > /dev/null

echo "done"

systemctl start postgresql.service
echo "Start postgres service!"

#-> nginx
systemctl start nginx.service
echo "Start nginx service!"
