【テーブルの作成】
-- ユーザテーブル
CREATE TABLE users (
id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
gender VARCHAR(10),
created_at DATE
);

-- 商品テーブル
CREATE TABLE products (
id INT PRIMARY KEY,
product_name VARCHAR(100),
price INT
);

-- 注文テーブル
CREATE TABLE orders (
id INT PRIMARY KEY,
user_id INT,
order_date DATE,
FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 注文明細テーブル
CREATE TABLE order_items (
id INT PRIMARY KEY,
order_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (product_id) REFERENCES products(id)
);


【ダミーデータの作成】
-- ユーザデータ
INSERT INTO users (id, name, age, gender, created_at) VALUES
(1, '山田太郎', 28, 'male', '2024-01-10'),
(2, '佐藤花子', 35, 'female', '2024-03-15'),
(3, '鈴木次郎', 42, 'male', '2023-08-20'),
(4, '田中美咲', 23, 'female', '2022-11-05'),
(5, '高橋健一', 30, 'male', '2024-06-01');

-- 商品データ
INSERT INTO products (id, product_name, price) VALUES
(1, 'テレビ', 50000),
(2, '冷蔵庫', 70000),
(3, '電子レンジ', 15000),
(4, '掃除機', 20000),
(5, '炊飯器', 18000);

-- 注文データ
INSERT INTO orders (id, user_id, order_date) VALUES
(1, 1, '2024-05-01'),
(2, 1, '2024-05-15'),
(3, 2, '2024-06-01'),
(4, 3, '2024-05-20'),
(5, 4, '2024-06-03'),
(6, 5, '2024-06-05');

-- 注文明細データ
INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
(1, 1, 1, 1), -- 山田がテレビを1台
(2, 1, 3, 2), -- 山田が電子レンジを2台
(3, 2, 2, 1), -- 山田が冷蔵庫を1台
(4, 3, 5, 1), -- 佐藤が炊飯器を1台
(5, 4, 4, 1), -- 鈴木が掃除機を1台
(6, 4, 3, 1), -- 鈴木が電子レンジを1台
(7, 5, 2, 1), -- 田中が冷蔵庫を1台
(8, 6, 1, 1), -- 高橋がテレビを1台
(9, 6, 5, 2); -- 高橋が炊飯器を2台


【設問の回答】
設問1: 
SELECT * FROM `users`;

設問2:
SELECT * FROM `users` WHERE `created_at` BETWEEN '2024-01-01' AND '2024-12-31';

設問3:
SELECT * FROM `users` WHERE `age` < 30 AND `gender` = 'female';

設問4:
SELECT `id`, `product_name`, `price` FROM `products`;

設問5: 
SELECT `users`.`id`, `users`.`name`, `orders`.`order_date`
FROM `orders`
JOIN `users` ON `orders`.`user_id` = `users`.`id`;

設問6:
SELECT `products`.`id`, `products`.`product_name`, `order_items`.`quantity`, `products`.`price`,
(`products`.`price` * `order_items`.`quantity`) AS `total_amount`
FROM `order_items`
JOIN `products` ON `order_items`.`product_id` = `products`.`id`;

設問7: 
SELECT `users`.`id`, `users`.`name`, COUNT(`orders`.`id`) AS `order_count`
FROM `users`
JOIN `orders` ON `users`.`id` = `orders`.`user_id`
GROUP BY `users`.`id`, `users`.`name`;

設問8:
SELECT `users`.`id`, `users`.`name`, SUM(`order_items`.`quantity` * `products`.`price`) AS `total_purchase`
FROM `users`
JOIN `orders` ON `users`.`id` = `orders`.`user_id`
JOIN `order_items` ON `orders`.`id` = `order_items`.`order_id`
JOIN `products` ON `order_items`.`product_id` = `products`.`id`
GROUP BY `users`.`id`, `users`.`name`;

設問9: 
SELECT `users`.`id`, `users`.`name`, SUM(`order_items`.`quantity` * `products`.`price`) AS `total`
FROM `users`
JOIN `orders` ON `users`.`id` = `orders`.`user_id`
JOIN `order_items` ON `orders`.`id` = `order_items`.`order_id`
JOIN `products` ON `order_items`.`product_id` = `products`.`id`
GROUP BY `users`.`id`, `users`.`name`
ORDER BY `total` DESC LIMIT 1;

設問10: 
SELECT `products`.`id`, `products`.`product_name`, SUM(`order_items`.`quantity`) AS `total_quantity`
FROM `products`
JOIN `order_items` ON `products`.`id` = `order_items`.`product_id`
GROUP BY `products`.`id`, `products`.`product_name`;

設問11: 
SELECT `id`, `name` FROM `users` WHERE `id` NOT IN (SELECT `user_id` FROM `orders`);

設問12: 
SELECT `order_id` FROM `order_items` GROUP BY `order_id` HAVING COUNT(`product_id`) >= 2;

設問13: 
SELECT DISTINCT `users`.`id`, `users`.`name`
FROM `users`
JOIN `orders` ON `users`.`id` = `orders`.`user_id`
JOIN `order_items` ON `orders`.`id` = `order_items`.`order_id`
JOIN `products` ON `order_items`.`product_id` = `products`.`id`
WHERE `products`.`product_name` = 'テレビ';

設問14: 
SELECT `orders`.`id` AS `order_id`, `orders`.`order_date`, `users`.`id` AS `user_id`, `users`.`name`, `products`.`product_name`, `order_items`.`quantity`,
(`order_items`.`quantity` * `products`.`price`) AS `total`
FROM `order_items`
JOIN `orders` ON `order_items`.`order_id` = `orders`.`id`
JOIN `users` ON `orders`.`user_id` = `users`.`id`
JOIN `products` ON `order_items`.`product_id` = `products`.`id`;

設問15: 
SELECT `products`.`id`, `products`.`product_name`
FROM `order_items`
JOIN `products` ON `order_items`.`product_id` = `products`.`id`
GROUP BY `products`.`id`, `products`.`product_name`
ORDER BY SUM(`order_items`.`quantity`) DESC LIMIT 1;

設問16: 
SELECT DATE_FORMAT(`order_date`, '%Y-%m') AS `month`, COUNT(`id`) AS `count`
FROM `orders`
GROUP BY `month`;

設問17: 
SELECT `id`, `product_name` FROM `products` WHERE `id` NOT IN (SELECT `product_id` FROM `order_items`);

設問18: 
CREATE INDEX `idx_product_id` ON `order_items`(`product_id`);

設問19: 
SELECT `users`.`id`, `users`.`name`, AVG(`sub`.`order_total`) AS `avg_amount`
FROM `users`
JOIN (SELECT `order_id`, SUM(`quantity` * `price`) AS `order_total`
FROM `order_items` JOIN `products` ON `product_id` = `products`.`id` GROUP BY `order_id`) AS `sub`
ON `sub`.`order_id` IN (SELECT `id` FROM `orders` WHERE `user_id` = `users`.`id`)
GROUP BY `users`.`id`, `users`.`name`;

設問20: 
SELECT `users`.`id`, `users`.`name`, MAX(`orders`.`order_date`) AS `latest_date`
FROM `users`
JOIN `orders` ON `users`.`id` = `orders`.`user_id`
GROUP BY `users`.`id`, `users`.`name`;

設問21
INSERT INTO `users` (`id`, `name`, `age`, `gender`, `created_at`) VALUES (6, '中村愛', 25, 'female', '2025-06-01');

設問22:
INSERT INTO `products` (`id`, `product_name`, `price`) VALUES (6, 'エアコン', 60000);

設問23:
INSERT INTO `orders` (`id`, `user_id`, `order_date`) VALUES (10, 1, '2025-06-10');

設問24:
INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`) VALUES (10, 10, 6, 1);

設問25:
UPDATE `users` SET `age` = 24 WHERE `name` = '田中美咲';

設問26:
UPDATE `products` SET `price` = `price` * 1.1;

設問27:
UPDATE `orders` SET `order_date` = '2024-05-01' WHERE `order_date` < '2024-05-01';

設問28:
DELETE FROM `users` WHERE `name` = '高橋健一';

設問29:
DELETE FROM `order_items` WHERE `order_id` = 5;

設問30:
DELETE FROM `products` WHERE `id` NOT IN (SELECT `product_id` FROM `order_items`);