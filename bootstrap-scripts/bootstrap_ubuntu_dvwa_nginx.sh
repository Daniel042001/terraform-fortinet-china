#!/bin/bash +xe

until ping -c1 globalsdns.fortinet.net >/dev/null 2>&1; do :; done

sudo apt-get update

sudo apt-get install -y nginx
sudo apt-get install -y php mysql-server
sudo apt-get install -y php-fpm php-mysql php-gd php-curl php-zip php-mbstring php-xml php-xmlrpc

UBUNTU=${versionUbuntu}
PHPFPM="7.2"
BINPHPFPM="php7.2-fpm"

if [[ $UBUNTU == "bionic1804" ]]; then
  PHPFPM="7.2"
  BINPHPFPM="php7.2-fpm"
elif [[ $UBUNTU == "focal2004" ]]; then
  PHPFPM="7.4"
  BINPHPFPM="php7.4-fpm"
elif [[ $UBUNTU == "jammy2204" ]]; then
  PHPFPM="8.1"
  BINPHPFPM="php8.1-fpm"
fi

cd /var/www/html
sudo git clone https://github.com/ethicalhack3r/DVWA.git
sudo cp /var/www/html/DVWA/config/config.inc.php.dist /var/www/html/DVWA/config/config.inc.php

sudo chown www-data:www-data /var/www/html/DVWA/hackable/uploads/
sudo chown www-data:www-data /var/www/html/DVWA/config
sudo chown www-data:www-data /var/www/html/DVWA/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

DB_PWD="1qaz@WSX"

cat > /home/ubuntu/init_dvwa_db.sql<<EOF
CREATE DATABASE dvwa;
CREATE USER 'dvwa'@'localhost' IDENTIFIED BY '$DB_PWD';
GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwa'@'localhost';
FLUSH PRIVILEGES;
exit;
EOF

sudo mysql -u root -p$DB_PWD < /home/ubuntu/init_dvwa_db.sql


sudo /bin/sed -i "s/\$_DVWA\[ 'db_password' \] = 'p@ssw0rd';/\$_DVWA\[ 'db_password' \] = '$DB_PWD';/" /var/www/html/DVWA/config/config.inc.php
sudo /bin/sed -i "s/\$_DVWA\[ 'default_security_level' \] = 'impossible';/\$_DVWA\[ 'default_security_level' \] = 'low';/" /var/www/html/DVWA/config/config.inc.php


sudo cat /dev/null > /etc/nginx/sites-available/dvwa.conf
cat > /etc/nginx/sites-available/dvwa.conf<<EOF
server {
    listen       80;
    server_name  localhost;
    server_name_in_redirect off;
    client_max_body_size    15M;

    root         /var/www/html;
    index        index.php index.html index.htm default.html default.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ /(conf|app|include|local)/ {
        deny all;
    }

    location ~ \.php$ {
        try_files     \$uri =404;
        fastcgi_pass  unix:/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include       fastcgi_params;
        fastcgi_param PHP_VALUE "
                max_execution_time = 300
                memory_limit = 128M
                post_max_size = 16M
                upload_max_filesize = 2M
                max_input_time = 300
                date.timezone = Asia/Shanghai
                always_populate_raw_post_data = -1
                session.save_path = /tmp
        ";
        fastcgi_buffers 8 256k;
        fastcgi_buffer_size 128k;
        fastcgi_intercept_errors on;
        fastcgi_busy_buffers_size 256k;
        fastcgi_temp_file_write_size 256k;
    }
}
EOF

sudo rm /etc/nginx/sites-enabled/default

sudo sed -i "s/php7.2-fpm/$BINPHPFPM/g" /etc/nginx/sites-available/dvwa.conf
sudo ln -s /etc/nginx/sites-available/dvwa.conf /etc/nginx/sites-enabled/

sudo sudo /bin/sed -i "s/allow_url_include = Off/allow_url_include = On/" /etc/php/$PHPFPM/fpm/php.ini

sudo systemctl stop nginx
sudo systemctl stop $BINPHPFPM

sudo systemctl start $BINPHPFPM
sudo systemctl start nginx
