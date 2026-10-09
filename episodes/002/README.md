# Folge 002 – PostgreSQL vs. MySQL: wann welches?
*Episode 002 – PostgreSQL vs. MySQL: which one when?*

Code zur Folge 002 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Dieselbe JSON-Abfrage in PostgreSQL (`postgresql.sql`) und MySQL 8.4/9.7 (`mysql_8.4.sql`); CTEs und Window Functions gibt es in beiden; transaktionale DDL in PostgreSQL (`CREATE TABLE` + `ROLLBACK`). `mysql_8.4.sql` läuft nicht im PostgreSQL-Container – Startbefehl steht oben in der Datei.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/002/postgresql.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/002/postgresql.sql
```

## Contents (English)
The same JSON query in PostgreSQL (`postgresql.sql`) and MySQL 8.4/9.7 (`mysql_8.4.sql`); both support CTEs and window functions; transactional DDL in PostgreSQL (`CREATE TABLE` + `ROLLBACK`). `mysql_8.4.sql` does not run in the PostgreSQL container – see the command at the top of the file.

## Dateien / Files
- [`mysql_8.4.sql`](mysql_8.4.sql)
- [`postgresql.sql`](postgresql.sql)

## Doku / Docs
- https://dev.mysql.com/doc/refman/8.4/en/json.html
- https://www.postgresql.org/docs/current/functions-json.html
