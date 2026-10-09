-- Folge 014 – Extensions: pgvector, PostGIS & Co.  ·  Episode 014
-- Läuft im normalen db-Container (pg_stat_statements ist dort per compose.yaml vorgeladen).
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep014 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep014;
SET search_path = ep014;

-- Welche Extensions bringt der Server mit? / Which extensions ship with the server?
SELECT name, default_version FROM pg_available_extensions
WHERE name IN ('pg_stat_statements', 'pg_trgm', 'postgis', 'vector')
ORDER BY name;

-- pg_stat_statements braucht shared_preload_libraries (siehe compose.yaml) + CREATE EXTENSION
-- pg_stat_statements needs shared_preload_libraries (see compose.yaml) + CREATE EXTENSION
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Etwas Last erzeugen / generate some load
CREATE TABLE t AS SELECT g AS id, md5(g::text) AS v FROM generate_series(1, 100000) g;
SELECT count(*) FROM t WHERE v LIKE 'ab%';
SELECT count(*) FROM t WHERE v LIKE 'cd%';

-- Teuerste Abfragen insgesamt / most expensive queries in total
SELECT round(total_exec_time::numeric, 1) AS total_ms, calls, left(query, 60) AS query
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 5;
