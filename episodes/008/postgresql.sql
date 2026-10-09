-- Folge 008 – PostgreSQL vs. MongoDB: SQL oder NoSQL?  ·  Episode 008
-- Dieselben Bestelldaten einmal relational, einmal dokumentenartig (JSONB).
-- The same order data, once relational, once document-style (JSONB).
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep008 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep008;
SET search_path = ep008;

-- Relational: ohne Wiederholungen, Beziehungen per Fremdschlüssel
CREATE TABLE customers (
  id   bigint PRIMARY KEY,
  name text NOT NULL,
  city text NOT NULL
);
CREATE TABLE orders (
  id          bigint PRIMARY KEY,
  customer_id bigint NOT NULL REFERENCES customers (id),
  total       numeric(10,2) NOT NULL
);
INSERT INTO customers VALUES (1, 'Ada', 'Kiel'), (2, 'Linus', 'Hamburg');
INSERT INTO orders VALUES (1001, 1, 129.90), (1002, 1, 15.00), (1003, 2, 42.50);

-- Code aus dem Video / code from the video
SELECT c.name, o.total FROM orders o
JOIN customers c ON c.id = o.customer_id;

-- Spontane Auswertung über Beziehungen / ad hoc report across relationships
SELECT c.city, count(*) AS orders, sum(o.total) AS revenue
FROM orders o JOIN customers c ON c.id = o.customer_id
GROUP BY c.city ORDER BY revenue DESC;

-- Dokumentenartig in PostgreSQL: zusammen gespeichert, was zusammen gelesen wird
-- Document-style in PostgreSQL: store together what's read together
CREATE TABLE order_docs (id text PRIMARY KEY, doc jsonb NOT NULL);
INSERT INTO order_docs VALUES
  ('o-1001', '{"customer": {"name": "Ada", "city": "Kiel"}, "items": [{"sku": "TSHIRT-XL", "qty": 2}], "total": 129.90}');
SELECT id, doc->'customer'->>'name' AS customer
FROM order_docs WHERE doc @> '{"customer": {"city": "Kiel"}}';
