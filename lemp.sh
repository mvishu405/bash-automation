#!/usr/bin/env bash
#
# Bash script for LEMP STACK.
#https://tecadmin.net/install-php-ubuntu-20-04/
#https://launchpad.net/ubuntu/+ppas

#read -p "ENTER DOMAIN NAME: " DOMAIN_NAME
#MYSQL_DATABASE_NAME=`echo "db_$DOMAIN_NAME" | iconv -t ascii//TRANSLIT | sed -r s/[~\^]+//g | sed -r s/[^a-zA-Z0-9]+/-/g | sed -r s/^-+\|-+$//g | tr A-Z a-z`
#echo $MYSQL_DATABASE_NAME


# Variable definitions.
read -p "ENTER DOMAIN NAME: " DOMAIN_NAME
NGINX_DOCUMENT_ROOT="www.$DOMAIN_NAME"
read -p "ENTER NGINX SERVER NAME: " NGINX_SERVER_NAME
read -p "ENTER PHP VERSION: " PHP_VERSION
read -p "ENTER MYSQL PASSWORD: " MYSQL_PASSWORD
MYSQL_DATABASE_NAME=`echo "db_$DOMAIN_NAME" | sed 's/\./_/g'`
CONFIG_SERVER="/$USER/config_server"

# Saving crenditial to afile for future refrence
echo "SAVING CREDENTIALS TO A $CONFIG_SERVER"
cat <<- EOF >> $CONFIG_SERVER
DOMAIN NAME: $DOMAIN_NAME
NGINX DOCUMENT ROOT: $NGINX_DOCUMENT_ROOT
NGINX SERVER NAME: $NGINX_SERVER_NAME
PHP VERSION: $PHP_VERSION
MYSQL PASSWORD: $MYSQL_PASSWORD
MYSQL DATABASE NAME: $MYSQL_DATABASE_NAME

EOF

#Get repositories for the latest software
sudo apt install software-properties-common
sudo apt-get update
sudo add-apt-repository -y ppa:nginx/development
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update

# Basics
sudo apt-get install -y git tmux vim curl wget zip unzip htop expect

# Nginx
sudo apt-get install -y nginx

# PHP
sudo apt-get install -y php$PHP_VERSION-fpm php$PHP_VERSION-cli php$PHP_VERSION-mcrypt php$PHP_VERSION-gd php$PHP_VERSION-mysql \
       php$PHP_VERSION-pgsql php$PHP_VERSION-imap php-memcached php$PHP_VERSION-mbstring php$PHP_VERSION-xml php$PHP_VERSION-curl \
       php$PHP_VERSION-bcmath php$PHP_VERSION-sqlite3 php$PHP_VERSION-xdebug php$PHP_VERSION-zip

# Composer
php -r "readfile('http://getcomposer.org/installer');" | sudo php -- --install-dir=/usr/bin/ --filename=composer

#Mysql
#sudo systemctl stop mysql
#sudo apt-get purge -y mysql-server mysql-client mysql-common mysql-server-core-* mysql-client-core-*
#sudo rm -rf /etc/mysql /var/lib/mysql
#sudo apt autoremove
#sudo apt autoclean
sudo apt update
sudo apt-get install -y mysql-server
sudo mysql_secure_installation
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';FLUSH PRIVILEGES;CREATE DATABASE ${MYSQL_DATABASE_NAME};"

#For Demo purpose
#mysql -u [username] -p [password] << EOF
#[Mysql Command]
#EOF

# Nginx Configuration
sudo mkdir -p "/var/www/$NGINX_DOCUMENT_ROOT"
sudo chown -R $USER:www-data /var/www/$NGINX_DOCUMENT_ROOT
sudo find /var/www/$NGINX_DOCUMENT_ROOT -type f -exec chmod 664 {} \;
sudo find /var/www/$NGINX_DOCUMENT_ROOT -type d -exec chmod 775 {} \;


> /etc/nginx/sites-available/default

cat <<- EOF >> /etc/nginx/sites-available/default
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/$NGINX_DOCUMENT_ROOT/public;

    index index.html index.htm index.nginx-debian.html index.php;

    #add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload';
    #add_header Content-Security-Policy "default-src 'self'; font-src *;img-src * data:; script-src *; style-src *";
    #add_header X-XSS-Protection "1; mode=block";
    #add_header X-Frame-Options "SAMEORIGIN";
    #add_header X-Content-Type-Options nosniff;
    #add_header Referrer-Policy "strict-origin";
    #add_header Permissions-Policy "geolocation=(),midi=(),sync-xhr=(),microphone=(),camera=(),magnetometer=(),gyroscope=(),fullscreen=(self),payment=()";

    server_name $NGINX_SERVER_NAME;

    client_max_body_size 100M;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }

    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php$PHP_VERSION-fpm.sock;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

#Generating ssh key
ssh-keygen -t rsa -b 2048 -C "mvishu405@gmail.com" -N '' -f ~/.ssh/id_rsa <<< y
cat ~/.ssh/id_rsa.pub >> $CONFIG_SERVER

#Delete html folder
cd /var/www && sudo rm -rf html
