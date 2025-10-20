CREATE DATABASE webapp;
CREATE USER 'webuser'@'192.168.56.12' IDENTIFIED BY 'webpass';
GRANT SELECT ON webapp.* TO 'webuser'@'192.168.56.12';
FLUSH PRIVILEGES;

USE webapp;

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