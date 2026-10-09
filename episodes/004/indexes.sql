-- Folge 004 – Indexes: warum Datenbanken langsam werden  ·  Episode 004 – Indexes
-- Erzeugt 1 Mio. Testzeilen (dauert einige Sekunden). / Creates 1M test rows (takes a few seconds).
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep004 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep004;
SET search_path = ep004;

CREATE TABLE orders (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id bigint NOT NULL,
  total       numeric(10,2) NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);
INSERT INTO orders (customer_id, total, created_at)
SELECT (random() * 100000)::bigint + 1,
       round((random() * 500)::numeric, 2),
       now() - random() * interval '365 days'
FROM generate_series(1, 1000000);
ANALYZE orders;

-- Ohne Index: Seq Scan liest jede Zeile / without an index: Seq Scan reads every row
EXPLAIN ANALYZE
SELECT * FROM orders WHERE customer_id = 42;

-- Code aus dem Video / code from the video
CREATE INDEX orders_customer_id_idx ON orders (customer_id);

-- Mit Index: Index Scan oder Bitmap Heap Scan – je nach geschätzter Trefferzahl
-- With an index: Index Scan or Bitmap Heap Scan – depending on the estimated row count
EXPLAIN ANALYZE
SELECT * FROM orders WHERE customer_id = 42;

-- Die Kehrseite: Speicherbedarf / the downside: storage
SELECT pg_size_pretty(pg_relation_size('orders'))                 AS table_size,
       pg_size_pretty(pg_relation_size('orders_customer_id_idx')) AS index_size;

-- Kleine Tabellen: ein Seq Scan ist oft schneller – der Planer entscheidet selbst
-- Small tables: a Seq Scan is often faster – the planner decides
CREATE TABLE tiny AS SELECT * FROM orders LIMIT 50;
CREATE INDEX tiny_customer_id_idx ON tiny (customer_id);
ANALYZE tiny;
EXPLAIN SELECT * FROM tiny WHERE customer_id = 42;
