-- Folge 009 – Constraints: Datenintegrität in der Datenbank  ·  Episode 009 – Constraints
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep009 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep009;
SET search_path = ep009;

CREATE TABLE customers (
  id   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL
);

-- Code aus dem Video / code from the video
CREATE TABLE orders (
  id          bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_no    text   NOT NULL UNIQUE,
  customer_id bigint NOT NULL REFERENCES customers (id),
  quantity    int    NOT NULL CHECK (quantity > 0)
);

INSERT INTO customers (name) VALUES ('Ada');
INSERT INTO orders (order_no, customer_id, quantity) VALUES ('A-1', 1, 2);

-- Jeder Weg in die Datenbank wird geprüft – auch Import-Skripte und Admin-Konsolen.
-- Every path into the database is checked – including import scripts and admin consoles.
DO $$
BEGIN
  BEGIN INSERT INTO orders (order_no, customer_id, quantity) VALUES (NULL, 1, 1);
  EXCEPTION WHEN not_null_violation THEN RAISE NOTICE 'NOT NULL:    %', SQLERRM; END;

  BEGIN INSERT INTO orders (order_no, customer_id, quantity) VALUES ('A-1', 1, 1);
  EXCEPTION WHEN unique_violation THEN RAISE NOTICE 'UNIQUE:      %', SQLERRM; END;

  BEGIN INSERT INTO orders (order_no, customer_id, quantity) VALUES ('A-2', 1, -3);
  EXCEPTION WHEN check_violation THEN RAISE NOTICE 'CHECK:       %', SQLERRM; END;

  BEGIN INSERT INTO orders (order_no, customer_id, quantity) VALUES ('A-3', 999, 1);
  EXCEPTION WHEN foreign_key_violation THEN RAISE NOTICE 'FOREIGN KEY: %', SQLERRM; END;

  -- Standard bei REFERENCES: Löschen eines Kunden mit Bestellungen wird verhindert (NO ACTION)
  -- Default for REFERENCES: deleting a customer that still has orders is blocked (NO ACTION)
  BEGIN DELETE FROM customers WHERE id = 1;
  EXCEPTION WHEN foreign_key_violation THEN RAISE NOTICE 'ON DELETE:   %', SQLERRM; END;
END $$;

-- NOT NULL erlaubt trotzdem einen leeren String – dafür braucht es einen CHECK.
-- NOT NULL still allows an empty string – that needs a CHECK.
ALTER TABLE customers ADD CONSTRAINT name_not_blank CHECK (btrim(name) <> '');

SELECT * FROM orders;
