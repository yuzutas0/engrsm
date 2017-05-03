#!/bin/bash

# ================================
# self-signed certificate
# ================================

mkdir /home/${USER}/ssl/

echo "*** Enter for all questions"
openssl req -new -x509 -sha256 -newkey rsa:2048 -days 365 -nodes -out /home/${USER}/ssl/fullchain.pem -keyout /home/${USER}/ssl/privkey.pem

chmod 600 /home/${USER}/ssl/*
chmod 700 /home/${USER}/ssl/

# TODO: use "let's encrypt" at production server

# ================================
# nginx settings for app
# ================================

mv /etc/nginx/conf.d/${APP}.conf /etc/nginx/conf.d/${APP}.conf.tmp

cat << _EOF > /etc/nginx/conf.d/${APP}.conf
  upstream unicorn_server {
    server unix:/var/www/${APP}/shared/tmp/sockets/unicorn.sock fail_timeout=0;
  }

  server_tokens off;
  add_header X-Frame-Options SAMEORIGIN;
  add_header X-Content-Type-Options nosniff;

  server {
    listen 80;
    listen [::]:80;
    server_name ${HOST};
    return 301 https://\$host\$request_uri;
  }

  server {
    set \$app ${APP};
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name ${HOST};

    ssl on;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE+RSAGCM:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!EXPORT:!DES:!3DES:!MD5:!DSS;

    ssl_certificate /home/${USER}/ssl/fullchain.pem;
    ssl_certificate_key /home/${USER}/ssl/privkey.pem;

    root /var/www/\$app/current/public;

    error_page 404 /404.html;
    error_page 422 /422.html;
    error_page 400 401 403 500 501 502 503 504 /500.html;

    gzip on;
    gzip_proxied any;
    gzip_min_length 1k;
    gzip_types text/css text/javascript application/x-javascript;

    location ~* \.php$ {
      deny all;
    }

    location / {
      try_files \$uri @unicorn;
    }

    location @unicorn {
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto https;
      proxy_set_header Host \$http_host;
      proxy_pass http://unicorn_server;
    }
  }

  server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    error_page 400 401 403 404 500 501 502 503 504 = /custom_404.html;

    location / {
      deny all;
    }

    location /custom_404.html {
      return 404 "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html>\n<head>\n<title>404 Not Found</title>\n</head>\n<body>\n<h1>Not Found</h1>\n<p>The requested URL was not found on this server.</p>\n</body>\n</html>";
      internal;
    }
  }

  server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    server_name _;

    ssl on;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE+RSAGCM:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!EXPORT:!DES:!3DES:!MD5:!DSS;

    ssl_certificate /home/${USER}/ssl/fullchain.pem;
    ssl_certificate_key /home/${USER}/ssl/privkey.pem;

    error_page 400 401 403 404 500 501 502 503 504 = /custom_404.html;

    location / {
      deny all;
    }

    location /custom_404.html {
      return 404 "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html>\n<head>\n<title>404 Not Found</title>\n</head>\n<body>\n<h1>Not Found</h1>\n<p>The requested URL was not found on this server.</p>\n</body>\n</html>";
      internal;
    }
  }
_EOF

# ================================
# nginx settings for all
# ================================

echo "*** Comment out 'server { ... }' directive"
echo -n "*** Is it OK to continue? [yes/no]"
read answer

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.tmp
vim /etc/nginx/nginx.conf

# ================================
# reload
# ================================

systemctl reload nginx
