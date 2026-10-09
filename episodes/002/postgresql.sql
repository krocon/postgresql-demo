-- Folge 002 – PostgreSQL vs. MySQL  ·  Episode 002 – PostgreSQL vs. MySQL
-- PostgreSQL-Seite des Vergleichs. Die MySQL-Seite steht in mysql_8.4.sql.
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep002 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep002;
SET search_path = ep002;

CREATE TABLE users (
  id   bigint PRIMARY KEY,
  data jsonb NOT NULL
);
INSERT INTO users VALUES
  (1, '{"city": "Kiel",    "plan": "pro"}'),
  (2, '{"city": "Hamburg", "plan": "free"}'),
  (3, '{"city": "Bremen",  "plan": "pro"}');

-- Code aus dem Video / code from the video
SELECT id, data->>'city' AS city FROM users
WHERE data @> '{"plan": "pro"}';

-- Beide Systeme können CTEs und Window Functions (MySQL seit 8.0):
-- Both systems support CTEs and window functions (MySQL since 8.0):
WITH pro AS (SELECT * FROM users WHERE data->>'plan' = 'pro')
SELECT id, row_number() OVER (ORDER BY id) AS rn FROM pro;

-- Ein Unterschied: Schemaänderungen laufen in PostgreSQL in Transaktionen.
-- One difference: schema changes in PostgreSQL are transactional.
BEGIN;
CREATE TABLE tmp_demo (id int);
ROLLBACK;
SELECT to_regclass('ep002.tmp_demo') AS tmp_demo_after_rollback;  -- NULL: Tabelle ist weg / table is gone
