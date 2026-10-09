#!/usr/bin/env bash
# Folge 013 – Restore testen: Dump in eine frische Datenbank einspielen, zählen, Dauer messen.
# Episode 013 – test the restore: load the dump into a fresh database, count rows, time it.
#   ./episodes/013/restore-test.sh backups/notes_2026-10-09_1200.dump
set -euo pipefail
cd "$(dirname "$0")/../.."
dump="${1:?Pfad zum Dump angeben / pass the dump path}"
# Paralleles Restore (-j) braucht eine Datei, kein stdin → erst in den Container kopieren
# Parallel restore (-j) needs a file, not stdin → copy it into the container first
docker compose cp "$dump" db:/tmp/restore.dump
start=$(date +%s)
docker compose exec -T db sh -c '
  dropdb   -U "$POSTGRES_USER" --if-exists notes_restore &&
  createdb -U "$POSTGRES_USER" notes_restore &&
  pg_restore -U "$POSTGRES_USER" -j 4 -d notes_restore /tmp/restore.dump &&
  psql -U "$POSTGRES_USER" -d notes_restore -c "SELECT schemaname, relname, n_live_tup FROM pg_stat_user_tables ORDER BY 1, 2;"'
echo "⏱  Restore-Dauer / duration: $(( $(date +%s) - start )) s"
docker compose exec -T db rm -f /tmp/restore.dump
