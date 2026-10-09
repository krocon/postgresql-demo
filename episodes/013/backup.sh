#!/usr/bin/env bash
# Folge 013 – Backup mit pg_dump im Custom-Format (aus dem Compose-Container).
# Episode 013 – backup with pg_dump in custom format (from the Compose container).
#   ./episodes/013/backup.sh                 → backups/notes_<Datum>.dump
set -euo pipefail
cd "$(dirname "$0")/../.."
mkdir -p backups
file="backups/notes_$(date +%Y-%m-%d_%H%M).dump"
docker compose exec -T db sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc' > "$file"
# Rollen und andere globale Objekte sind NICHT im Dump / roles and other globals are NOT in the dump:
docker compose exec -T db sh -c 'pg_dumpall -U "$POSTGRES_USER" --globals-only' > "${file%.dump}_globals.sql"
ls -lh "$file"
