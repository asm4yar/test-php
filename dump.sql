-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               11.7.2-MariaDB - Arch Linux
-- Операционная система:         Linux
-- HeidiSQL Версия:              12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Дамп структуры базы данных test-php
CREATE DATABASE IF NOT EXISTS `test-php` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `test-php`;

-- Дамп структуры для таблица test-php.geos
CREATE TABLE IF NOT EXISTS `geos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `currency_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы test-php.geos: ~3 rows (приблизительно)
INSERT INTO `geos` (`id`, `name`, `currency_code`) VALUES
	(1, 'USA', 'USD'),
	(2, 'Germany', 'EUR'),
	(3, 'Kazakhstan', 'KZT');

-- Дамп структуры для таблица test-php.leads
CREATE TABLE IF NOT EXISTS `leads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `geo_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `geo_id` (`geo_id`),
  KEY `idx_leads_composite` (`product_id`,`geo_id`,`created_at`),
  CONSTRAINT `leads_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `leads_ibfk_2` FOREIGN KEY (`geo_id`) REFERENCES `geos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы test-php.leads: ~6 rows (приблизительно)
INSERT INTO `leads` (`id`, `product_id`, `geo_id`, `created_at`) VALUES
	(1, 1, 1, '2025-04-15 13:01:00'),
	(2, 1, 1, '2025-04-15 13:05:00'),
	(3, 1, 2, '2025-04-15 13:08:00'),
	(6, 2, 1, '2025-04-15 13:09:00'),
	(4, 2, 3, '2025-04-15 13:03:00'),
	(5, 2, 3, '2025-04-15 13:06:00');

-- Дамп структуры для таблица test-php.price_coefficients
CREATE TABLE IF NOT EXISTS `price_coefficients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `geo_id` int(11) DEFAULT NULL,
  `coefficient` decimal(5,4) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_coefficients_unique` (`product_id`,`geo_id`),
  KEY `geo_id` (`geo_id`),
  CONSTRAINT `price_coefficients_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `price_coefficients_ibfk_2` FOREIGN KEY (`geo_id`) REFERENCES `geos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы test-php.price_coefficients: ~4 rows (приблизительно)
INSERT INTO `price_coefficients` (`id`, `product_id`, `geo_id`, `coefficient`, `updated_at`) VALUES
	(1, 1, 1, 0.9500, '2025-04-15 13:10:00'),
	(2, 1, 2, 0.9000, '2025-04-15 13:10:00'),
	(3, 2, 1, 0.9700, '2025-04-15 13:10:00'),
	(4, 2, 3, 0.8800, '2025-04-15 13:10:00');

-- Дамп структуры для таблица test-php.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы test-php.products: ~2 rows (приблизительно)
INSERT INTO `products` (`id`, `name`) VALUES
	(1, 'iPhone 14'),
	(2, 'Galaxy S23');

-- Дамп структуры для таблица test-php.product_geo
CREATE TABLE IF NOT EXISTS `product_geo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `geo_id` int(11) DEFAULT NULL,
  `base_price` decimal(10,2) DEFAULT NULL,
  `delivery_cost` decimal(10,2) DEFAULT NULL,
  `final_price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_product_geo_unique` (`product_id`,`geo_id`),
  KEY `geo_id` (`geo_id`),
  CONSTRAINT `product_geo_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `product_geo_ibfk_2` FOREIGN KEY (`geo_id`) REFERENCES `geos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Дамп данных таблицы test-php.product_geo: ~6 rows (приблизительно)
INSERT INTO `product_geo` (`id`, `product_id`, `geo_id`, `base_price`, `delivery_cost`, `final_price`) VALUES
	(1, 1, 1, 700.00, 20.00, 720.00),
	(2, 1, 2, 680.00, 30.00, 710.00),
	(3, 1, 3, 500.00, 50.00, 550.00),
	(4, 2, 1, 650.00, 25.00, 675.00),
	(5, 2, 2, 640.00, 35.00, 675.00),
	(6, 2, 3, 480.00, 55.00, 535.00);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
