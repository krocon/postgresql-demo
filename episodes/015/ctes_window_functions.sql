-- Folge 015 – CTEs und Window Functions  ·  Episode 015 – CTEs and window functions
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep015 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep015;
SET search_path = ep015;

CREATE TABLE orders (
  id         bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  category   text NOT NULL,
  total      numeric(10,2) NOT NULL,
  created_at timestamptz NOT NULL
);
INSERT INTO orders (category, total, created_at)
SELECT (ARRAY['books', 'shirts', 'lamps'])[1 + (g % 3)],
       round((10 + random() * 190)::numeric, 2),
       timestamptz '2026-01-01' + (g % 270) * interval '1 day'
FROM generate_series(1, 5000) g;

-- Code aus dem Video: Umsatz pro Monat + Differenz zum Vormonat
-- Code from the video: revenue per month + change vs. previous month
WITH monthly AS (
  SELECT date_trunc('month', created_at) AS month, sum(total) AS revenue
  FROM orders GROUP BY 1
)
SELECT month, revenue,
       revenue - lag(revenue) OVER (ORDER BY month) AS diff
FROM monthly ORDER BY month;

-- row_number: Top 3 Bestellungen pro Kategorie / top 3 orders per category
SELECT * FROM (
  SELECT category, id, total,
         row_number() OVER (PARTITION BY category ORDER BY total DESC) AS rn
  FROM orders
) ranked
WHERE rn <= 3
ORDER BY category, rn;

-- Laufende Summe pro Kategorie (erste 5 Tage) / running total per category (first 5 days)
SELECT category, created_at::date AS day, sum(total) AS day_total,
       sum(sum(total)) OVER (PARTITION BY category ORDER BY created_at::date) AS running_total
FROM orders
WHERE created_at < timestamptz '2026-01-06'
GROUP BY category, created_at::date
ORDER BY category, day;

-- WITH RECURSIVE: Kategoriebaum durchlaufen / walk a category tree
CREATE TABLE categories (id int PRIMARY KEY, parent_id int REFERENCES categories (id), name text NOT NULL);
INSERT INTO categories VALUES
  (1, NULL, 'Shop'), (2, 1, 'Kleidung'), (3, 2, 'T-Shirts'), (4, 2, 'Hoodies'),
  (5, 1, 'Wohnen'), (6, 5, 'Lampen');

WITH RECURSIVE tree AS (
  SELECT id, name, 1 AS depth, name AS path FROM categories WHERE parent_id IS NULL
  UNION ALL
  SELECT c.id, c.name, t.depth + 1, t.path || ' > ' || c.name
  FROM categories c JOIN tree t ON c.parent_id = t.id
)
SELECT repeat('  ', depth - 1) || name AS category, path FROM tree ORDER BY path;
