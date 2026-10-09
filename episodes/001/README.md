# Folge 001 – Warum PostgreSQL? Fünf Gründe
*Episode 001 – Why PostgreSQL? Five reasons*

Code zur Folge 001 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Tabelle mit Identity-Spalte, CHECK-Constraint und JSONB; ein abgewiesener negativer Betrag; JSONB + Window Function in einer Abfrage; Ähnlichkeitssuche mit `pg_trgm`.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/001/why_postgresql.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/001/why_postgresql.sql
```

## Contents (English)
Table with identity column, CHECK constraint and JSONB; a rejected negative total; JSONB + window function in one query; fuzzy matching with `pg_trgm`.

## Dateien / Files
- [`why_postgresql.sql`](why_postgresql.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/intro-whatis.html
- https://www.postgresql.org/docs/current/ddl-constraints.html
