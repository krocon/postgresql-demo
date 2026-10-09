# Folge 004 – Indexes: warum Datenbanken langsam werden
*Episode 004 – Indexes: why databases get slow*

Code zur Folge 004 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
1 Mio. Testzeilen per `generate_series`, `EXPLAIN ANALYZE` vor und nach `CREATE INDEX`, Größe von Tabelle und Index, und warum der Planer bei kleinen Tabellen trotzdem scannt. Im Testlauf (PostgreSQL 18.4): *Parallel Seq Scan* ≈ 30 ms → *Bitmap Index Scan* ≈ 0,1 ms; Index ≈ 9 MB neben 57 MB Tabelle. Deine Zahlen weichen ab – das ist der Punkt: selbst messen.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/004/indexes.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/004/indexes.sql
```

## Contents (English)
1M test rows via `generate_series`, `EXPLAIN ANALYZE` before and after `CREATE INDEX`, table and index size, and why the planner still scans small tables. Test run (PostgreSQL 18.4): *Parallel Seq Scan* ≈ 30 ms → *Bitmap Index Scan* ≈ 0.1 ms; index ≈ 9 MB next to a 57 MB table. Your numbers will differ – that's the point: measure yourself.

## Dateien / Files
- [`indexes.sql`](indexes.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/indexes.html
- https://www.postgresql.org/docs/current/using-explain.html
