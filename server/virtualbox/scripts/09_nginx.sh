#!/bin/bash

# ================================
# install
# ================================

yum -y install nginx

systemctl start nginx
systemctl enable nginx

# ================================
# settings for HTTP
# ================================

cat << _EOF > /etc/nginx/conf.d/${APP}.conf
  upstream unicorn_server {
    server unix:/var/www/${APP}/shared/tmp/sockets/unicorn.sock fail_timeout=0;
  }

  server_tokens off;
  add_header X-Frame-Options SAMEORIGIN;
  add_header X-Content-Type-Options nosniff;

  server {
    set \$app ${APP};
    listen 80;
    listen [::]:80;
    server_name ${HOST};

    root /var/www/\$app/current/public;

    error_page 404 /404.html;
    error_page 422 /422.html;
    error_page 400 401 403 500 501 502 503 504 /500.html;

    gzip on;
    gzip_proxied any;
    gzip_min_length 1k;
    gzip_types text/html text/css text/javascript application/x-javascript;

    location ~* \.php$ {
      deny all;
    }

    location / {
      try_files \$uri @unicorn;
    }

    location @unicorn {
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header Host \$http_host;
      proxy_pass http://unicorn_server;
    }
  }

  server {
    listen 80;
    listen [::]:80;
    server_name _;
    error_page 403 404 500 503 = /custom_404.html;

    location / {
      deny all;
    }

    location /custom_404.html {
      return 404 "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>404 Not Found</title>\n</head><body>\n<h1>Not Found</h1>\n<p>The requested URL \$request_uri was not found on this server.</p>\n</body></html>";
      internal;
    }
  }
_EOF

systemctl reload nginx
