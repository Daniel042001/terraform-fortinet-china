#!/bin/bash +xe

until ping -c1 globalsdns.fortinet.net >/dev/null 2>&1; do :; done

sudo apt-get update
sudo apt-get -y upgrade

sudo apt-get install -y nginx
sudo apt-get install -y php-fpm


UBUNTU=${versionUbuntu}
BINPHPFPM="php7.2-fpm"

if [[ $UBUNTU == "bionic1804" ]]; then
  BINPHPFPM="php7.2-fpm"
elif [[ $UBUNTU == "focal2004" ]]; then
  BINPHPFPM="php7.4-fpm"
elif [[ $UBUNTU == "jammy2204" ]]; then
  BINPHPFPM="php8.1-fpm"
fi

sudo cat /dev/null > /usr/share/nginx/html/index.php
# cat > /usr/share/nginx/html/index.php<<EOF
#  (<?php phpinfo(); ?>)
# EOF

cat > /usr/share/nginx/html/index.php<<EOF
<?php ob_start(); ?>

<html>
<head>
<title>Proprietary Network</title>
<style>body {margin-top: 40px; background-color: #333;} </style>
</head>
<body>
<div style="color:white;text-align:center">
<h1>WARNING!!!</h1>
<h2>YOUR ACCESS IS BEING MONITORED!</h2>
<p><font size="3em" face="consolas" color="red">******************************************************************<br /> *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;NO UNAUTHORIZED ACCESS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> * Use of the Network is restricted to authorized users. User&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> * activity is recorded by system personal. Anyone using the&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> * Network expressly consents to such monitoring and recording.&nbsp;&nbsp;&nbsp;*<br /> *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> * BE ADVISED: if possible criminal activity is detected, system&nbsp;&nbsp;*<br /> * records, along with certain personal information may be&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> * provided to law enforcement officials.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<br /> ****************************************************************** </font></p>

<p><font size="3em" face="arial" color="yellow">
<?php
echo "Client IP address [REMOTE_ADDR]: ".\$_SERVER['REMOTE_ADDR'];
?>
</p>

<p><font size="3em" face="arial" color="yellow">
<?php
echo "Server IP address (exposed) [HTTP_HOST]: ".\$_SERVER['HTTP_HOST'];
?>
</p>

<p><font size="3em" face="arial" color="yellow">
<?php
echo "Server IP address (real) [SERVER_ADDR]: ".\$_SERVER['SERVER_ADDR'];
?>
</p>

</div>
</body>
</html>

<?php ob_end_flush(); ?>
EOF


sudo cat /dev/null > /etc/nginx/sites-available/default
cat > /etc/nginx/sites-available/default<<EOF
server {
    listen       80;
    server_name  localhost;
    server_name_in_redirect off;
    client_max_body_size    15M;

    root         /usr/share/nginx/html;
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

sudo sed -i "s/php7.2-fpm/$BINPHPFPM/g" /etc/nginx/sites-available/default

sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

sudo service nginx stop
sudo service $BINPHPFPM stop

sudo service nginx start
sudo service $BINPHPFPM start