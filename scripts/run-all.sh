#!/usr/bin/env bash
# Führt die SQL-Dateien aller Folgen im laufenden Compose-Container aus (bricht beim ersten Fehler ab).
# Runs every episode's SQL inside the running Compose container (stops at the first error).
#   ./scripts/run-all.sh                                   # alle Folgen (startet db bei Bedarf)
#   ./scripts/run-all.sh 004                               # nur Folge 004
set -euo pipefail
cd "$(dirname "$0")/.."
filter="${1:-}"
# Startet den db-Service (falls nötig) und wartet, bis der Healthcheck "healthy" meldet.
# Beim allerersten Start initialisiert das Image erst das Datenverzeichnis – das dauert einige Sekunden.
# Starts the db service (if needed) and waits until its healthcheck reports "healthy".
echo "⏳ warte auf / waiting for db (healthy) …"
docker compose up -d --wait db
for f in episodes/*/*.sql; do
  case "$f" in
    */mysql*|*/vector*) echo "⏭  $f (läuft nicht im db-Container / not for the db container)"; continue ;;
  esac
  [[ -n "$filter" && "$f" != episodes/$filter/* ]] && continue
  echo "▶  $f"
  docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -q -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "/$1"' _ "$f" >/dev/null
done
echo "✅ fertig / done"
