# Folge 008 – PostgreSQL vs. MongoDB: SQL oder NoSQL?
*Episode 008 – PostgreSQL vs. MongoDB: SQL or NoSQL?*

Code zur Folge 008 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Dieselben Bestellungen relational (JOIN, Auswertung per GROUP BY) und dokumentenartig – einmal als JSONB in PostgreSQL, einmal in MongoDB (`mongodb.js`, mit Aggregation-Pipeline). `mongodb.js` läuft nicht im PostgreSQL-Container – Startbefehl steht oben in der Datei.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/008/postgresql.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/008/postgresql.sql
```

## Contents (English)
The same orders relationally (JOIN, GROUP BY report) and document-style – once as JSONB in PostgreSQL, once in MongoDB (`mongodb.js`, with an aggregation pipeline). `mongodb.js` does not run in the PostgreSQL container – see the command at the top of the file.

## Dateien / Files
- [`mongodb.js`](mongodb.js)
- [`postgresql.sql`](postgresql.sql)

## Doku / Docs
- https://www.mongodb.com/docs/manual/core/transactions/
- https://www.postgresql.org/docs/current/tutorial-join.html
