<?php

function updatePriceCoefficients($pdo, $redis) {
    // Получаем все уникальные пары (product_id, geo_id)
    $stmt = $pdo->query("SELECT DISTINCT product_id, geo_id FROM product_geo");
    $pairs = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($pairs as $pair) {
        $productId = $pair['product_id'];
        $geoId = $pair['geo_id'];

        // Кол-во лидов за последний час
        $stmtLeads = $pdo->prepare("
            SELECT COUNT(*) as lead_count FROM leads 
            WHERE product_id = :productId AND geo_id = :geoId 
            AND created_at >= NOW() - INTERVAL 1 HOUR
        ");
        $stmtLeads->execute(['productId' => $productId, 'geoId' => $geoId]);
        $leadCount = $stmtLeads->fetchColumn();

        // Пример расчета коэффициента
        // Больше лидов — ниже цена: коэффициент = 1 - min(0.5, leadCount * 0.01)
        $coefficient = max(0.5, 1 - min(0.5, $leadCount * 0.01));

        // Обновляем таблицу
        $stmtUpdate = $pdo->prepare("
            INSERT INTO price_coefficients (product_id, geo_id, coefficient, updated_at)
            VALUES (:productId, :geoId, :coef, NOW())
            ON DUPLICATE KEY UPDATE coefficient = :coef, updated_at = NOW()
        ");
        $stmtUpdate->execute([
            'productId' => $productId,
            'geoId' => $geoId,
            'coef' => $coefficient
        ]);

        // Удаляем кеш, чтобы в следующий раз пересчитался
        $cacheKey = "price:$productId:$geoId";
        $redis->del([$cacheKey]);
    }
}
