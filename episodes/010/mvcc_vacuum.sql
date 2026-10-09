-- Folge 010 – MVCC und VACUUM  ·  Episode 010 – MVCC and VACUUM
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep010 CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep010;
SET search_path = ep010;

-- autovacuum für diese Demo-Tabelle aus, damit die Zahlen stabil bleiben – in echten Systemen NIE abschalten!
-- autovacuum off for this demo table only, to keep the numbers stable – NEVER do this in real systems!
CREATE TABLE events (
  id     bigint PRIMARY KEY,
  status text NOT NULL
) WITH (autovacuum_enabled = false);
INSERT INTO events SELECT g, 'new' FROM generate_series(1, 200000) g;
ANALYZE events;

-- MVCC: ein UPDATE schreibt eine neue Zeilenversion (neue ctid, neue xmin)
-- MVCC: an UPDATE writes a new row version (new ctid, new xmin)
SELECT ctid, xmin, * FROM events WHERE id = 1;
UPDATE events SET status = 'seen' WHERE id = 1;
SELECT ctid, xmin, * FROM events WHERE id = 1;

SELECT pg_size_pretty(pg_relation_size('events')) AS size_before;

-- Massen-Update: jede Zeile bekommt eine neue Version, die alten bleiben als tote Tupel liegen
-- Mass update: every row gets a new version, the old ones stay behind as dead tuples
UPDATE events SET status = 'done';
SELECT pg_size_pretty(pg_relation_size('events')) AS size_after_update;   -- fast doppelt / almost double

SELECT pg_stat_force_next_flush();
SELECT relname, n_live_tup, n_dead_tup, last_autovacuum, last_vacuum
FROM pg_stat_user_tables WHERE relname = 'events';

-- VACUUM gibt den Platz zur Wiederverwendung frei – die Datei bleibt so groß
-- VACUUM frees the space for reuse – the file keeps its size
VACUUM events;
SELECT pg_size_pretty(pg_relation_size('events')) AS size_after_vacuum;

-- VACUUM FULL schreibt die Tabelle neu und schrumpft sie – sperrt sie aber exklusiv
-- VACUUM FULL rewrites and shrinks the table – but locks it exclusively
VACUUM FULL events;
SELECT pg_size_pretty(pg_relation_size('events')) AS size_after_vacuum_full;

-- Code aus dem Video: Tabellen mit den meisten toten Tupeln
-- Code from the video: tables with the most dead tuples
SELECT relname, n_live_tup, n_dead_tup, last_autovacuum
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC
LIMIT 5;

-- Lange offene Transaktionen blockieren das Aufräumen für alle:
-- Long-running open transactions block cleanup for everyone:
SELECT pid, state, now() - xact_start AS xact_age, left(query, 60) AS query
FROM pg_stat_activity
WHERE state LIKE 'idle in transaction%'
ORDER BY xact_age DESC;
