# Folge 013 – Backup und Restore
*Episode 013 – Backup and restore*

Code zur Folge 013 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
`backup.sh`: `pg_dump -Fc` aus dem Container nach `backups/` plus `pg_dumpall --globals-only` (Rollen sind nicht im Dump). `restore-test.sh`: Dump in die frische Datenbank `notes_restore` einspielen (`pg_restore -j 4`), Zeilen zählen, Dauer messen. Paralleles Restore braucht eine Datei, kein stdin – deshalb `docker compose cp`. Für minimalen Datenverlust: physisches Basis-Backup + WAL-Archiv (Point-in-Time-Recovery), z. B. mit [pgBackRest](https://pgbackrest.org/).

## Ausführen / Run
```bash
./scripts/run-all.sh                              # etwas Inhalt erzeugen / create some data
./episodes/013/backup.sh                           # → backups/notes_<datum>.dump
./episodes/013/restore-test.sh backups/notes_*.dump
```
Ohne Docker (Homebrew PostgreSQL 18) / without Docker:
```bash
pg_dump -Fc -d notes -f notes.dump
createdb notes_restore
pg_restore -j 4 -d notes_restore notes.dump
psql -d notes_restore -c "SELECT count(*) FROM ep009.orders;"
```

## Contents (English)
`backup.sh`: `pg_dump -Fc` from the container into `backups/` plus `pg_dumpall --globals-only` (roles are not in the dump). `restore-test.sh`: loads the dump into a fresh `notes_restore` database (`pg_restore -j 4`), counts rows, times it. Parallel restore needs a file, not stdin – hence `docker compose cp`. For minimal data loss: physical base backup + WAL archive (point-in-time recovery), e.g. with [pgBackRest](https://pgbackrest.org/).

## Dateien / Files
- [`backup.sh`](backup.sh)
- [`restore-test.sh`](restore-test.sh)

## Doku / Docs
- https://www.postgresql.org/docs/current/backup.html
- https://www.postgresql.org/docs/current/app-pgrestore.html
