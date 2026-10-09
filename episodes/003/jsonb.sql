-- Folge 003 – JSONB: wann Tabellen nicht reichen  ·  Episode 003 – JSONB
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep003 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep003;
SET search_path = ep003;

-- Code aus dem Video / code from the video
CREATE TABLE products (
  id    bigint PRIMARY KEY,
  name  text NOT NULL,
  attrs jsonb NOT NULL DEFAULT '{}'
);
CREATE INDEX ON products USING gin (attrs);

INSERT INTO products VALUES
  (1, 'T-Shirt Basic', '{"size": "XL", "color": "black"}'),
  (2, 'T-Shirt Logo',  '{"size": "M",  "color": "white"}'),
  (3, 'Schreibtischlampe', '{"voltage": 230, "color": "black"}'),
  (4, 'SQL-Buch',      '{"isbn": "978-3-00-000000-0", "pages": 320}');

SELECT name FROM products WHERE attrs @> '{"size": "XL"}';

-- -> liefert JSON, ->> liefert Text / -> returns JSON, ->> returns text
SELECT name, attrs->'color' AS color_json, attrs->>'color' AS color_text
FROM products WHERE attrs ? 'color';

-- jsonb normalisiert: Schlüsselreihenfolge und Leerzeichen bleiben nicht erhalten, doppelte Schlüssel: der letzte gewinnt
-- jsonb normalizes: key order and whitespace are not kept, duplicate keys: last one wins
SELECT '{"b": 1,   "a": 2, "b": 3}'::json  AS as_json,
       '{"b": 1,   "a": 2, "b": 3}'::jsonb AS as_jsonb;

-- Einzelnes Feld oft abgefragt? Ausdrucks-Index statt GIN über alles.
-- Single field queried often? An expression index instead of GIN over everything.
CREATE INDEX products_color_idx ON products ((attrs->>'color'));
SELECT name FROM products WHERE attrs->>'color' = 'black';

-- Trade-off Validierung: ohne Schema prüfst du selbst, z. B. per CHECK
-- Trade-off validation: without a schema you validate yourself, e.g. with CHECK
ALTER TABLE products
  ADD CONSTRAINT attrs_is_object CHECK (jsonb_typeof(attrs) = 'object'),
  ADD CONSTRAINT voltage_is_number CHECK (NOT attrs ? 'voltage' OR jsonb_typeof(attrs->'voltage') = 'number');

DO $$
BEGIN
  INSERT INTO products VALUES (5, 'Kaputte Lampe', '{"voltage": "230V"}');
EXCEPTION WHEN check_violation THEN
  RAISE NOTICE 'Erwartet / expected: %', SQLERRM;
END $$;
