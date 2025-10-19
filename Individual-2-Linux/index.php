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
    $host = '192.168.56.10';
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
    }
    ?>
    
</body>
</html>