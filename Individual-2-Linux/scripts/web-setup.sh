#!/bin/bash

apt-get update
apt-get install -y nginx php7.4-fpm php7.4-mysql

mkdir -p /var/www/html
cp /vagrant/index.php /var/www/html/

# Configure nginx
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }
}
EOF

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

systemctl restart nginx
systemctl restart php7.4-fpm