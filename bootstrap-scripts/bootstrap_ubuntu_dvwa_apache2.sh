#!/bin/bash +xe

until ping -c1 globalsdns.fortinet.net >/dev/null 2>&1; do :; done

sudo apt-get update
sudo apt-get install -y apache2 php mysql-server php-mysql
sudo apt-get install -y php-curl php-zip php-mbstring php-mcrypt php-xml php-xmlrpc
sudo apt-get install -y php-gd

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

sudo chown www-data:www-data /var/www/html/DVWA/hackable/uploads/
sudo chown www-data:www-data /var/www/html/DVWA/config
sudo chown www-data:www-data /var/www/html/DVWA/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

sudo /bin/sed -i "s/allow_url_include = Off/allow_url_include = On/" /etc/php/$PHPFPM/apache2/php.ini


sudo service apache2 stop
sudo service apache2 start
