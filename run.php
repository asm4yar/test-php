<?php
require_once 'vendor/autoload.php';

$redis = new Predis\Client();
$pdo = new Pdo\Mysql("mysql:host=localhost;dbname=test-php", 'test-php', 'test-php');


function getFinalPrice($productId, $geoId, PDO $pdo, $redis)
{
    $cacheKey = "price:$productId:$geoId";

    // Попытка взять из кеша
    $cachedPrice = $redis->get($cacheKey);
    if ($cachedPrice !== null) {
        return (float)$cachedPrice;
    }

    // Получение данных из БД
    $stmt = $pdo->prepare("
        SELECT pg.base_price, pg.delivery_cost, pc.coefficient 
        FROM product_geo pg 
        LEFT JOIN price_coefficients pc 
            ON pg.product_id = pc.product_id AND pg.geo_id = pc.geo_id
        WHERE pg.product_id = :productId AND pg.geo_id = :geoId
    ");
    $stmt->execute(['productId' => $productId, 'geoId' => $geoId]);

    $row = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        return null;
    }

    $base = $row['base_price'];
    $delivery = $row['delivery_cost'];
    $coefficient = $row['coefficient'] ?? 1.0;

    $finalPrice = ($base + $delivery) * $coefficient;

    // Кешируем
    $redis->setex($cacheKey, 600, $finalPrice);

    return $finalPrice;
}

echo "<b>price ";
echo getFinalPrice(1, 1, $pdo, $redis);
echo " </b>\n";
