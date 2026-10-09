-- Folge 001 – Warum PostgreSQL? Fünf Gründe  ·  Episode 001 – Why PostgreSQL? Five reasons
-- Jede Folge arbeitet in einem eigenen Schema und ist beliebig oft ausführbar.
-- Every episode uses its own schema and can be re-run any time.
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep001 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep001;
SET search_path = ep001;

SELECT version();

-- Code aus dem Video / code from the video
CREATE TABLE orders (
  id      bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  total   numeric(10,2) NOT NULL CHECK (total >= 0),
  details jsonb
);
CREATE EXTENSION IF NOT EXISTS pg_trgm;

INSERT INTO orders (total, details) VALUES
  (49.90,  '{"channel": "web", "items": 2}'),
  (129.00, '{"channel": "app", "items": 5}'),
  (15.50,  '{"channel": "web", "items": 1}');

-- Grund 2: Datenintegrität – ein negativer Betrag wird abgewiesen
-- Reason 2: data integrity – a negative total is rejected
DO $$
BEGIN
  INSERT INTO orders (total) VALUES (-5);
EXCEPTION WHEN check_violation THEN
  RAISE NOTICE 'Erwartet / expected: %', SQLERRM;
END $$;

-- Grund 3: starkes SQL – JSONB und eine Window Function in einer Abfrage
-- Reason 3: powerful SQL – JSONB and a window function in one query
SELECT id, total,
       details->>'channel'           AS channel,
       sum(total) OVER (ORDER BY id) AS running_total
FROM orders
ORDER BY id;

-- Grund 4: erweiterbar – Ähnlichkeitssuche mit der Extension pg_trgm
-- Reason 4: extensible – fuzzy matching with the pg_trgm extension
SELECT similarity('PostgreSQL', 'Postgres') AS similarity;
