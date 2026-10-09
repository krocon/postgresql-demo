# Folge 007 – PostgreSQL und Spring Boot
*Episode 007 – PostgreSQL and Spring Boot*

Code zur Folge 007 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Spring Boot 4.1 (Java 21) mit `spring-boot-starter-jdbc`, PostgreSQL-Treiber und `JdbcClient` (`app/`). REST: `GET /notes`, `GET /notes/{id}`, `POST /notes`. Die Tabelle legt `schema.sql` im Schema `ep007` an. Spring Data JPA lohnt sich bei vielen Entitäten mit klassischem CRUD; für volle SQL-Kontrolle passt JDBC oft besser.

## Ausführen / Run
```bash
docker compose up -d --wait               # Datenbank aus dem Hauptordner / database from the root
cd episodes/007/app
set -a; source ../../../.env; set +a      # POSTGRES_USER / POSTGRES_PASSWORD / POSTGRES_DB
./mvnw spring-boot:run
# zweites Terminal / second terminal:
curl -X POST localhost:8080/notes -H 'Content-Type: application/json' -d '{"text": "Erste Notiz"}'
curl localhost:8080/notes
```
Ohne Docker (Homebrew PostgreSQL 18, Benutzer = dein macOS-Login, ohne Passwort) / without Docker:
```bash
createdb notes
cd episodes/007/app && POSTGRES_USER=$USER POSTGRES_PASSWORD= ./mvnw spring-boot:run
```

## Contents (English)
Spring Boot 4.1 (Java 21) with `spring-boot-starter-jdbc`, the PostgreSQL driver and `JdbcClient` (`app/`). REST: `GET /notes`, `GET /notes/{id}`, `POST /notes`. `schema.sql` creates the table in schema `ep007`. Spring Data JPA pays off with many entities and classic CRUD; for full SQL control JDBC is often the better fit.

## Dateien / Files
- [`app`](app)

## Doku / Docs
- https://docs.spring.io/spring-boot/reference/data/sql.html
- https://docs.spring.io/spring-framework/reference/data-access/jdbc/core.html#jdbc-JdbcClient
