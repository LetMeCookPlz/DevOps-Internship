#!/bin/bash

useradd -m -s /bin/bash bastion

# Copy SSH keys
mkdir -p /home/bastion/.ssh
cp /vagrant/scripts/ssh-keys/db-key /home/bastion/.ssh/
cp /vagrant/scripts/ssh-keys/web-key /home/bastion/.ssh/
cp /vagrant/scripts/ssh-keys/bastion-key.pub /home/bastion/.ssh/authorized_keys
chmod 600 /home/bastion/.ssh/*
chmod 700 /home/bastion/.ssh/
chown -R bastion:bastion /home/bastion/.ssh/

cat > /home/bastion/.ssh/config <<EOF
Host database
    HostName 192.168.56.10
    User root
    IdentityFile /home/bastion/.ssh/db-key
    StrictHostKeyChecking no

Host webserver
    HostName 192.168.56.11
    User root
    IdentityFile /home/bastion/.ssh/web-key
    StrictHostKeyChecking no
EOF

systemctl restart ssh