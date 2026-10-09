# Folge 011 – Migrationen mit Flyway
*Episode 011 – Migrations with Flyway*

Code zur Folge 011 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Das Projekt aus Folge 007, aber das Schema verwaltet Flyway: `spring-boot-starter-flyway` + `flyway-database-postgresql`, Migrationen in `src/main/resources/db/migration` (`V1__create_notes.sql`, `V2__add_due_date.sql`). Beim Start legt Flyway das Schema `ep011` und `flyway_schema_history` an und führt nur neue Versionen aus. Ausgeführte Migrationen nie ändern – Korrekturen als neue Version. `CREATE INDEX CONCURRENTLY` braucht eine eigene Migration.

## Ausführen / Run
```bash
docker compose up -d --wait               # Datenbank aus dem Hauptordner / database from the root
cd episodes/011/app
set -a; source ../../../.env; set +a      # POSTGRES_USER / POSTGRES_PASSWORD / POSTGRES_DB
./mvnw spring-boot:run
# zweites Terminal / second terminal:
curl -X POST localhost:8080/notes -H 'Content-Type: application/json' -d '{"text": "Erste Notiz", "dueDate": "2026-12-31"}'
curl localhost:8080/notes
```
Ohne Docker (Homebrew PostgreSQL 18, Benutzer = dein macOS-Login, ohne Passwort) / without Docker:
```bash
createdb notes
cd episodes/011/app && POSTGRES_USER=$USER POSTGRES_PASSWORD= ./mvnw spring-boot:run
```

## Contents (English)
The project from episode 007, but Flyway manages the schema: `spring-boot-starter-flyway` + `flyway-database-postgresql`, migrations in `src/main/resources/db/migration` (`V1__create_notes.sql`, `V2__add_due_date.sql`). On startup Flyway creates schema `ep011` and `flyway_schema_history` and only runs new versions. Never edit applied migrations – fixes go into a new version. `CREATE INDEX CONCURRENTLY` needs its own migration.

## Dateien / Files
- [`app`](app)

## Doku / Docs
- https://documentation.red-gate.com/flyway
- https://docs.spring.io/spring-boot/how-to/data-initialization.html#howto.data-initialization.migration-tool.flyway
