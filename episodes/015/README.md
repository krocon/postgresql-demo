# Folge 015 – CTEs und Window Functions
*Episode 015 – CTEs and window functions*

Code zur Folge 015 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Die Abfrage aus dem Video (Umsatz pro Monat + Differenz zum Vormonat mit `WITH` und `lag() OVER`), Top 3 pro Kategorie mit `row_number()`, laufende Summe mit `sum() OVER`, ein Kategoriebaum mit `WITH RECURSIVE`.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/015/ctes_window_functions.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/015/ctes_window_functions.sql
```

## Contents (English)
The query from the video (revenue per month + change vs. previous month with `WITH` and `lag() OVER`), top 3 per category with `row_number()`, running total with `sum() OVER`, a category tree with `WITH RECURSIVE`.

## Dateien / Files
- [`ctes_window_functions.sql`](ctes_window_functions.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/queries-with.html
- https://www.postgresql.org/docs/current/tutorial-window.html
