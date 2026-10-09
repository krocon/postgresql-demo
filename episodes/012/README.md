# Folge 012 – Connection Pooling
*Episode 012 – Connection pooling*

Code zur Folge 012 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
`max_connections` (Standard 100, davon 3 für Superuser reserviert), wer gerade verbunden ist (ein Serverprozess pro Verbindung), die Rechnung Instanzen × Poolgröße. `application.yaml` zeigt die HikariCP-Einstellungen aus dem Video; dieselben Werte stehen in `episodes/011/app`. Externer Pooler: [PgBouncer](https://www.pgbouncer.org/features.html) – im Transaktionsmodus funktionieren sitzungsweite Funktionen wie `SET` und Session-Advisory-Locks nicht zuverlässig.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/012/connections.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/012/connections.sql
```

## Contents (English)
`max_connections` (default 100, 3 of them reserved for superusers), who is connected right now (one server process per connection), the math instances × pool size. `application.yaml` shows the HikariCP settings from the video; the same values are in `episodes/011/app`. External pooler: [PgBouncer](https://www.pgbouncer.org/features.html) – in transaction mode, session-level features like `SET` and session advisory locks don't work reliably.

## Dateien / Files
- [`application.yaml`](application.yaml)
- [`connections.sql`](connections.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/runtime-config-connection.html
- https://github.com/brettwooldridge/HikariCP#gear-configuration-knobs-baby
