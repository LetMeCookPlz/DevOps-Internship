#!/bin/bash

# Update system and install dependencies
apt-get update
apt-get install -y nginx php8.1-fpm php8.1-mysql mysql-client

# Configure PHP-FPM
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.1/fpm/php.ini
systemctl enable php8.1-fpm
systemctl start php8.1-fpm

# Configure nginx for PHP
cat > /etc/nginx/sites-available/default << 'NGINXCONF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.php index.html index.htm;
    server_name _;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
NGINXCONF

# Database initialization
mysql -h ${db_host} -u ${db_username} -p${db_password} << 'EOL'
CREATE DATABASE IF NOT EXISTS webapp;
CREATE USER IF NOT EXISTS 'webuser'@'%' IDENTIFIED BY 'webpass';
GRANT SELECT ON webapp.* TO 'webuser'@'%';
FLUSH PRIVILEGES;

USE webapp;

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

INSERT IGNORE INTO products (name, price) VALUES 
('Laptop', 999.99),
('Mouse', 29.99),
('Keyboard', 79.99),
('Monitor', 199.99);
EOL

# Create PHP webpage
cat > /var/www/html/index.php << 'EOL'
<!DOCTYPE html>
<html>
<head>
    <title>Product Catalog</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; max-width: 600px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>Product Catalog</h1>
    
    <?php
    $host = '${db_host}';
    $dbname = 'webapp';
    $username = 'webuser';
    $password = 'webpass';
    
    try {
        $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $stmt = $pdo->query("SELECT id, name, price FROM products");
        $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if (count($products) > 0) {
            echo "<table>";
            echo "<tr><th>ID</th><th>Product Name</th><th>Price</th></tr>";
            foreach ($products as $product) {
                echo "<tr>";
                echo "<td>" . htmlspecialchars($product['id']) . "</td>";
                echo "<td>" . htmlspecialchars($product['name']) . "</td>";
                echo "<td>$" . htmlspecialchars($product['price']) . "</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p>No products found.</p>";
        }
    } catch(PDOException $e) {
        echo "<p style='color: red;'>Connection failed: " . htmlspecialchars($e->getMessage()) . "</p>";
        echo "<p>Debug info - Host: " . htmlspecialchars($host) . "</p>";
    }
    ?>
    
</body>
</html>
EOL

# Set permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

systemctl restart nginx
systemctl restart php8.1-fpm