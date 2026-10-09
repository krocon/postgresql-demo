# Folge 014 – Extensions: pgvector, PostGIS & Co.
*Episode 014 – Extensions: pgvector, PostGIS & co.*

Code zur Folge 014 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
`extensions.sql` (normaler `db`-Container): verfügbare Extensions, `pg_stat_statements` (in `compose.yaml` per `shared_preload_libraries` vorgeladen) und die teuersten Abfragen. `vector.sql`: der Code aus dem Video mit pgvector – braucht den Service `vector` (Image `pgvector/pgvector:pg18`, Port 5433). PostGIS gibt es als Image `postgis/postgis`. Bei Managed-Anbietern vorher prüfen, welche Extensions erlaubt sind.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/014/extensions.sql'
# pgvector:
docker compose --profile vector up -d vector
docker compose exec -T vector sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/014/vector.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/014/extensions.sql
```

## Contents (English)
`extensions.sql` (regular `db` container): available extensions, `pg_stat_statements` (preloaded via `shared_preload_libraries` in `compose.yaml`) and the most expensive queries. `vector.sql`: the code from the video with pgvector – needs the `vector` service (image `pgvector/pgvector:pg18`, port 5433). PostGIS is available as the `postgis/postgis` image. With managed providers, check which extensions are allowed first.

## Dateien / Files
- [`extensions.sql`](extensions.sql)
- [`vector.sql`](vector.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/pgstatstatements.html
- https://github.com/pgvector/pgvector
- https://postgis.net/documentation/
