#!/usr/bin/env bash


#Installing a set of utilities for the django web-server
# - system user
# - nginx
# - postgres
# - systemd
# - python35
# - custom vim


#----------------------------------------------------------------------------
#Package install

yes Y | yum install epel-release
yes Y | yum update

yes Y | yum install gcc
yes Y | yum install systemd
yes Y | yum install memcached

yes Y | yum install postgresql-server
yes Y | yum install postgresql-devel
yes Y | yum install postgresql-contrib

yes Y | yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yes Y | yum -y install python35u
yes Y | yum -y install python35u-pip

yum -y install nginx


#----------------------------------------------------------------------------
#Prapair work environment

#-> vim configs
wget -O ~/.vimrc http://dumpz.org/25712/nixtext/
update-alternatives --set editor /usr/bin/vim.basic

#-> prepair user
useradd -m hotdog -s /bin/bash
cp ~/.vimrc /home/hotdog

chown -R hotdog:hotdog /home/hotdog


#----------------------------------------------------------------------------
#Prapair system services

#-> postgres
sed -i "s/ident/md5/g" /var/lib/pgsql/data/pg_hba.conf
postgresql-setup initdb

systemctl start postgresql.service

#-> nginx
systemctl start nginx.service
