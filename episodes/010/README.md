# Folge 010 – MVCC und VACUUM
*Episode 010 – MVCC and VACUUM*

Code zur Folge 010 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Neue Zeilenversion (`ctid`, `xmin`) nach einem UPDATE; Massen-Update auf 200.000 Zeilen: Tabelle wächst von ≈ 8,6 MB auf ≈ 17 MB, `n_dead_tup` ≈ 200.000; `VACUUM` gibt Platz frei (Datei bleibt groß), `VACUUM FULL` schrumpft (sperrt exklusiv); Abfrage auf `idle in transaction`. Autovacuum ist nur für diese Demo-Tabelle aus. **Lange offene Transaktion selbst ausprobieren:** in einem zweiten Terminal `BEGIN; SELECT 1;` offen lassen, dann `UPDATE` + `VACUUM VERBOSE ep010.events;` – die toten Tupel bleiben.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/010/mvcc_vacuum.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/010/mvcc_vacuum.sql
```

## Contents (English)
New row version (`ctid`, `xmin`) after an UPDATE; mass update on 200,000 rows: the table grows from ≈ 8.6 MB to ≈ 17 MB, `n_dead_tup` ≈ 200,000; `VACUUM` frees space (file stays big), `VACUUM FULL` shrinks it (exclusive lock); query for `idle in transaction`. Autovacuum is off for this demo table only. **Try a long-running transaction:** in a second terminal leave `BEGIN; SELECT 1;` open, then run `UPDATE` + `VACUUM VERBOSE ep010.events;` – the dead tuples stay.

## Dateien / Files
- [`mvcc_vacuum.sql`](mvcc_vacuum.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/mvcc-intro.html
- https://www.postgresql.org/docs/current/routine-vacuuming.html
