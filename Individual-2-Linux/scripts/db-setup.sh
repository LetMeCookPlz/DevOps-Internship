#!/bin/bash

apt-get update

# Pre-set MySQL root password to avoid prompt during installation
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

apt-get install -y mysql-server

# Configure MySQL to listen on private network
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Create database and user
mysql -uroot -proot < /vagrant/scripts/init.sql

# Setup SSH for bastion access
mkdir -p /root/.ssh
cp /vagrant/scripts/ssh-keys/db-key.pub /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

systemctl restart mysql
systemctl restart ssh

# Configure firewall (allow traffic from bastion only)
iptables -t filter -A INPUT -p tcp --dport 3306 -s 192.168.56.12 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 3306 -j DROP