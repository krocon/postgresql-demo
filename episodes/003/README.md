# Folge 003 – JSONB: wann Tabellen nicht reichen
*Episode 003 – JSONB: when tables aren't enough*

Code zur Folge 003 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
`products` mit festen Spalten + `attrs jsonb`, GIN-Index, die Operatoren `->`, `->>`, `@>`, `?`; json vs. jsonb (Reihenfolge, doppelte Schlüssel); Ausdrucks-Index für ein einzelnes Feld; Validierung per CHECK.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/003/jsonb.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/003/jsonb.sql
```

## Contents (English)
`products` with fixed columns + `attrs jsonb`, GIN index, the operators `->`, `->>`, `@>`, `?`; json vs. jsonb (order, duplicate keys); expression index for a single field; validation via CHECK.

## Dateien / Files
- [`jsonb.sql`](jsonb.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/datatype-json.html
- https://www.postgresql.org/docs/current/functions-json.html
