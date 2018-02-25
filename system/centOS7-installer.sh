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
	printf "${RED}system-centOS7-installer.sh was skipped.${NC}\n"
	exit 1
fi

#----------------------------------------------------------------------------
#Package install

printf "${CYAN}Start install system packages...${NC}\n"

yes Y | yum install epel-release 				2>&1 > /dev/null
yes Y | yum update 								2>&1 > /dev/null
printf "update...       ${GREEN}ok${NC}\n"

yes Y | yum install gcc 						2>&1 > /dev/null
printf "gcc...          ${GREEN}ok${NC}\n"

yes Y | yum install sudo 						2>&1 > /dev/null
printf "sudo...         ${GREEN}ok${NC}\n"

yes Y | yum install systemd 					2>&1 > /dev/null
printf "systemd...      ${GREEN}ok${NC}\n"

yes Y | yum install memcached 					2>&1 > /dev/null
printf "memcached...    ${GREEN}ok${NC}\n"

yes Y | yum install postgresql-server 			2>&1 > /dev/null
yes Y | yum install postgresql-devel			2>&1 > /dev/null
yes Y | yum install postgresql-contrib 			2>&1 > /dev/null
printf "postgresql...   ${GREEN}ok${NC}\n"

yes Y | yum -y install https://centos7.iuscommunity.org/ius-release.rpm 2>&1 > /dev/null
if [ "$?" -ne "0" ]; then
	echo "Submission failed"
fi
echo "Submission successful."


yes Y | yum -y install python35u 				2>&1 > /dev/null
yes Y | yum -y install python35u-pip			2>&1 > /dev/null
yes Y | yum -y install python35u-devel.x86_64	2>&1 > /dev/null
printf "python35...     ${GREEN}ok${NC}\n"

yum -y install nginx 							2>&1 > /dev/null
printf "nginx...        ${GREEN}ok${NC}\n"


#----------------------------------------------------------------------------
#Prapair work environment

printf "${CYAN}Init work environment...${NC}\n"

#-> vim configs
wget -O ~/.vimrc http://dumpz.org/25712/nixtext/ 	2>&1 > /dev/null
update-alternatives --set editor /usr/bin/vim.basic 2>&1 > /dev/null
printf "vim configs...  ${GREEN}ok${NC}\n"

#-> prepair user
useradd -m hotdog -s /bin/bash						2>&1 > /dev/null

mkdir -p /home/hotdog/$APP_NAME/djapp 				2>&1 > /dev/null
mkdir -p /home/hotdog/$APP_NAME/media				2>&1 > /dev/null
mkdir -p /home/hotdog/$APP_NAME/logs				2>&1 > /dev/null

chown -R hotdog:hotdog /home/hotdog 				2>&1 > /dev/null
printf "prepair user...  ${GREEN}ok${NC}\n"

printf "done.\n"


#----------------------------------------------------------------------------
#Prapair system services

printf "${CYAN}Init postgres...${NC}\n"

#-> postgres
sed -i "s/ident/md5/g" /var/lib/pgsql/data/pg_hba.conf
postgresql-setup initdb 2>&1 > /dev/null

printf "done.\n"

systemctl start postgresql.service
printf "${GREEN}Start postgresql.service${NC}\n"

#-> nginx
systemctl start nginx.service
printf "${GREEN}Start nginx.service${NC}\n"
