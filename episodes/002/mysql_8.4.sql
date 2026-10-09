-- Folge 002 – MySQL-Seite des Vergleichs (MySQL 8.4 LTS / 9.7 LTS).
-- NICHT für den PostgreSQL-Container. Zum Ausprobieren z. B.:
--   docker run --rm -d --name mysql-demo -e MYSQL_ROOT_PASSWORD=change-me -p 127.0.0.1:3306:3306 mysql:8.4
--   docker exec -i mysql-demo mysql -uroot -pchange-me < episodes/002/mysql_8.4.sql
CREATE DATABASE IF NOT EXISTS ep002;
USE ep002;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id   BIGINT PRIMARY KEY,
  data JSON NOT NULL
);
INSERT INTO users VALUES
  (1, '{"city": "Kiel",    "plan": "pro"}'),
  (2, '{"city": "Hamburg", "plan": "free"}'),
  (3, '{"city": "Bremen",  "plan": "pro"}');

-- Code aus dem Video / code from the video
SELECT id, data->>'$.city' AS city FROM users
WHERE JSON_CONTAINS(data, '{"plan": "pro"}');

-- CTEs und Window Functions gibt es auch hier (seit 8.0):
WITH pro AS (SELECT * FROM users WHERE data->>'$.plan' = 'pro')
SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn FROM pro;

-- DDL ist in MySQL nicht transaktional: CREATE TABLE beendet eine offene Transaktion (impliziter COMMIT).
-- DDL in MySQL is not transactional: CREATE TABLE implicitly commits an open transaction.
