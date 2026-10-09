-- Folge 005 – Transaktionen: ACID einfach erklärt  ·  Episode 005 – Transactions: ACID explained
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep005 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep005;
SET search_path = ep005;

CREATE TABLE accounts (
  id      int PRIMARY KEY,
  owner   text NOT NULL,
  balance numeric(12,2) NOT NULL CHECK (balance >= 0)   -- Consistency: nie unter null / never below zero
);
INSERT INTO accounts VALUES (1, 'A', 500), (2, 'B', 100);

-- Atomicity: Code aus dem Video / code from the video
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
SELECT * FROM accounts ORDER BY id;   -- A: 400, B: 200

-- ROLLBACK macht alles rückgängig / ROLLBACK undoes everything
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
ROLLBACK;
SELECT * FROM accounts ORDER BY id;   -- unverändert / unchanged: A: 400, B: 200

-- Alles oder nichts: Überweisung von 1.000 € scheitert am CHECK – auch die Gutschrift wird verworfen
-- All or nothing: a 1,000 € transfer fails the CHECK – the credit is discarded too
CREATE PROCEDURE transfer(from_id int, to_id int, amount numeric)
LANGUAGE plpgsql AS $$
BEGIN
  UPDATE accounts SET balance = balance + amount WHERE id = to_id;
  UPDATE accounts SET balance = balance - amount WHERE id = from_id;
END $$;

DO $$
BEGIN
  CALL transfer(1, 2, 1000);
EXCEPTION WHEN check_violation THEN
  RAISE NOTICE 'Erwartet / expected: %', SQLERRM;
END $$;
SELECT * FROM accounts ORDER BY id;   -- immer noch / still: A: 400, B: 200

-- Isolation: Standard ist Read Committed / default is Read Committed
SHOW default_transaction_isolation;

-- Strenger pro Transaktion / stricter per transaction
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT sum(balance) AS total_in_snapshot FROM accounts;
COMMIT;

-- Durability: Commits landen im Write-Ahead-Log; synchronous_commit kann das bewusst lockern
-- Durability: commits go to the write-ahead log; synchronous_commit can relax this on purpose
SHOW synchronous_commit;   -- on (Standard / default)
