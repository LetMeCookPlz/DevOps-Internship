#!/bin/bash

# Configuration
DB_NAME="user_db"
DB_USER="new_user"
DB_PASS="example_password123"

cat > /etc/my.cnf << EOF
[client]
user=root
password=${DB_PASS}
host=127.0.0.1
EOF

# Create database, table and user
mysql -e "
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;

USE ${DB_NAME};

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

INSERT INTO products (name, price) VALUES 
('Laptop', 999.99),
('Mouse', 29.99),
('Keyboard', 79.99),
('Monitor', 199.99);
"

verify_changes() {
  mysql -e "SHOW GRANTS FOR '${DB_USER}'@'localhost';"
  mysql -e "USE ${DB_NAME}; SELECT * FROM products;"
  echo -e "^^^ After $1 ^^^\n"
}

verify_changes "Creation"

# Create a backup
mysqldump --all-databases > /tmp/full_backup.sql

# Remove database and user
mysql -e "
DROP TABLE IF EXISTS ${DB_NAME}.users;
DROP USER IF EXISTS '${DB_USER}'@'localhost';
DROP DATABASE IF EXISTS ${DB_NAME};
FLUSH PRIVILEGES;
"
verify_changes "Deletion"

# Restore database from backup
mysql < /tmp/full_backup.sql
mysql -e "FLUSH PRIVILEGES;"
verify_changes "Restoration"