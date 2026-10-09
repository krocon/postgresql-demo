# Folge 009 – Constraints: Datenintegrität in der Datenbank
*Episode 009 – Constraints: data integrity in the database*

Code zur Folge 009 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Die Tabelle aus dem Video und fünf abgewiesene Versuche: NOT NULL, UNIQUE, CHECK, FOREIGN KEY und das Löschen eines Kunden mit Bestellungen. Dazu: NOT NULL erlaubt `''` – dafür braucht es einen CHECK.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/009/constraints.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/009/constraints.sql
```

## Contents (English)
The table from the video and five rejected attempts: NOT NULL, UNIQUE, CHECK, FOREIGN KEY and deleting a customer who still has orders. Plus: NOT NULL allows `''` – that needs a CHECK.

## Dateien / Files
- [`constraints.sql`](constraints.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/ddl-constraints.html
