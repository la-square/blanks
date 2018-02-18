#!/usr/bin/env bash

#Script create basic settings of nginx service

#Example:
#nginx-basic-config.sh

#Require:
#installed nginx service

#----------------------------------------------------------------------------
#Prepair nginx

mkdir /etc/nginx/sites-available
mkdir /etc/nginx/sites-enabled

mkdir /etc/nginx/conf.d
mv /etc/nginx/mime.types /etc/nginx/conf.d
rm -rf /etc/nginx/mime.types.default

rm -rf /etc/nginx/fastcgi.conf
rm -rf /etc/nginx/fastcgi.conf.default

rm -rf /etc/nginx/fastcgi_params
rm -rf /etc/nginx/fastcgi_params.default

rm -rf /etc/nginx/nginx.conf
rm -rf /etc/nginx/nginx.conf.default

rm -rf /etc/nginx/uwsgi_params.default

rm -rf /etc/nginx/scgi_params
rm -rf /etc/nginx/scgi_params.default

rm -rf /etc/nginx/default.d

#----------------------------------------------------------------------------
#Init nginx.conf

touch /etc/nginx/nginx.conf

chmod 0744 /etc/nginx/nginx.conf
cat >> /etc/nginx/nginx.conf << EOF
user hotdog;

worker_processes auto;
worker_rlimit_nofile 65535;

pid /run/nginx.pid;
error_log /var/log/nginx/error.log;

events {
	worker_connections 40960;
	accept_mutex off;
}

http {
	sendfile on;
	server_tokens off;
	map_hash_max_size 4096;
	types_hash_max_size 2048;
	server_names_hash_bucket_size 512;

	include conf.d/mime.types;
	default_type application/octet-stream;

	access_log /var/log/nginx/access.log combined buffer=4m flush=1s;
	error_log /var/log/nginx/error.log;

	client_body_buffer_size 1M;
	client_header_buffer_size 1M;
	large_client_header_buffers 128 8k;

	gzip  on;
	gzip_buffers 16 8k;
	gzip_comp_level 6;
	gzip_http_version 1.1;
	gzip_min_length 256;
	gzip_proxied any;
	gzip_vary on;
	gzip_types
		text/xml application/xml application/atom+xml application/rss+xml application/xhtml+xml image/svg+xml
		text/javascript application/javascript application/x-javascript
		text/x-json application/json application/x-web-app-manifest+json
		text/css text/plain text/x-component
		font/opentype application/x-font-ttf application/vnd.ms-fontobject
		image/x-icon;
	gzip_disable  "msie6";

	open_file_cache max=1000 inactive=20s;
	open_file_cache_valid 30s;
	open_file_cache_min_uses 2;
	open_file_cache_errors on;

	include sites-enabled/*;
}

EOF

#----------------------------------------------------------------------------
#Restart daemon
chown -R hotdog:hotdog /home/hotdog

systemctl daemon-reload
systemctl restart nginx.service
