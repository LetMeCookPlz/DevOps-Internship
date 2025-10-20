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

# Setup SSH for bastion access
mkdir -p /root/.ssh

cp /vagrant/scripts/ssh-keys/bastion-key /root/.ssh/
cp /vagrant/scripts/ssh-keys/web-key.pub /root/.ssh/authorized_keys

chmod 600 /root/.ssh/*
chmod 700 /root/.ssh/

# Create systemd service for MySQL tunnel through bastion
cat > /etc/systemd/system/mysql-tunnel.service <<EOF
[Unit]
Description=MySQL SSH Tunnel via Bastion
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/ssh -i /root/.ssh/bastion-key -o StrictHostKeyChecking=no -L 3306:192.168.56.10:3306 bastion@192.168.56.12 -N
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

systemctl daemon-reload
systemctl enable mysql-tunnel
systemctl start mysql-tunnel

systemctl restart nginx
systemctl restart php7.4-fpm
systemctl restart ssh