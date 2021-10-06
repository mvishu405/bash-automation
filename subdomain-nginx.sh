#!/usr/bin/env bash

# Variable definitions.
read -p "ENTER SUB DOMAIN NAME: " SUB_DOMAIN_NAME
read -p "ENTER PHP VERSION: " PHP_VERSION
NGINX_AVAILABLE_VHOSTS='/etc/nginx/sites-available'
NGINX_ENABLED_VHOSTS='/etc/nginx/sites-enabled'
WEB_DIR='/var/www'

# Functions
ok() { echo -e '\e[32m'$SUB_DOMAIN_NAME'\e[m'; } # Green

ok "Creating the config files for your subdomain."

# Create the Nginx config file.
cat > $NGINX_AVAILABLE_VHOSTS/$SUB_DOMAIN_NAME <<EOF
server {
    listen 80;
    
    root /var/www/$SUB_DOMAIN_NAME/public;

    index index.html index.htm index.nginx-debian.html index.php;
    
    #add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload';
    #add_header Content-Security-Policy "default-src 'self'; font-src *;img-src * data:; script-src *; style-src *";
    #add_header X-XSS-Protection "1; mode=block";
    #add_header X-Frame-Options "SAMEORIGIN";
    #add_header X-Content-Type-Options nosniff;
    #add_header Referrer-Policy "strict-origin";
    #add_header Permissions-Policy "geolocation=(),midi=(),sync-xhr=(),microphone=(),camera=(),magnetometer=(),gyroscope=(),fullscreen=(self),payment=()";

    server_name $SUB_DOMAIN_NAME;

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

# Create {public,log} directories.
mkdir -p $WEB_DIR/$SUB_DOMAIN_NAME/public

# Create index.html file.
cat > $WEB_DIR/$SUB_DOMAIN_NAME/public/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
        <title>You are in the subdomain $SUB_DOMAIN_NAME</title>
        <meta charset="utf-8" />
</head>
<body class="container">
        <header><h1>You are in the subdomain $SUB_DOMAIN_NAME<h1></header>
        <div id="wrapper">
                This is the body of your subdomain page.
        </div>
        <br>
        <footer>© $(date +%Y)</footer>
</body>
</html>
EOF

sudo chown -R $USER:www-data /var/www/$SUB_DOMAIN_NAME
sudo find /var/www/$SUB_DOMAIN_NAME -type f -exec chmod 664 {} \;    
sudo find /var/www/$SUB_DOMAIN_NAME -type d -exec chmod 775 {} \;

# Enable site by creating symbolic link.
sudo ln -s $NGINX_AVAILABLE_VHOSTS/$SUB_DOMAIN_NAME $NGINX_ENABLED_VHOSTS/$SUB_DOMAIN_NAME

# Restart the Nginx server.
read -p "A restart to Nginx is required for the subdomain to be defined. Do you wish to restart nginx? (y/n): " prompt
if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
    /etc/init.d/nginx restart;
fi

ok "Subdomain is created for $SUB_DOMAIN_NAME."