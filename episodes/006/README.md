# Folge 006 – PostgreSQL in Docker Compose
*Episode 006 – PostgreSQL in Docker Compose*

Code zur Folge 006 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Die vollständige Fassung des Video-Ausschnitts ist [`compose.yaml`](../../compose.yaml) im Hauptordner: `postgres:18`, Zugangsdaten aus `.env`, Port nur auf `127.0.0.1`, Named Volume unter `/var/lib/postgresql` (neu ab 18), Healthcheck mit `pg_isready`. `check_setup.sql` zeigt Version und Datenverzeichnis (`/var/lib/postgresql/18/docker`). Eine App im selben Compose-File wartet mit `depends_on: db: condition: service_healthy`. **Nur für die Entwicklung** – Produktion braucht Secrets, Backups, Monitoring und Updates.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/006/check_setup.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/006/check_setup.sql
```

## Contents (English)
The full version of the excerpt from the video is [`compose.yaml`](../../compose.yaml) in the root: `postgres:18`, credentials from `.env`, port bound to `127.0.0.1` only, named volume at `/var/lib/postgresql` (new in 18), healthcheck with `pg_isready`. `check_setup.sql` shows version and data directory (`/var/lib/postgresql/18/docker`). An app in the same Compose file waits via `depends_on: db: condition: service_healthy`. **Development only** – production needs secrets, backups, monitoring and updates.

## Dateien / Files
- [`check_setup.sql`](check_setup.sql)

## Doku / Docs
- https://hub.docker.com/_/postgres
- https://docs.docker.com/reference/compose-file/services/#healthcheck
