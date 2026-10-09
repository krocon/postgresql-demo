# postgresql-demo

Code und SQL zur Videoreihe **„PostgreSQL kompakt in 60 Sekunden“** – ein Thema pro Folge, jede Folge mit eigenem Ordner unter `episodes/NNN/`.
*Code and SQL for the video series **“PostgreSQL essentials in 60 seconds”** – one topic per episode, each in its own folder under `episodes/NNN/`.*

## Schnellstart / Quick start

Voraussetzung: Docker mit Compose v2 (z. B. Docker Desktop). / Requires Docker with Compose v2.

```bash
git clone https://github.com/krocon/postgresql-demo.git
cd postgresql-demo
cp .env.example .env            # Passwort ändern / change the password
docker compose up -d --wait     # PostgreSQL 18 auf / on 127.0.0.1:5432, wartet bis "healthy"
./scripts/run-all.sh            # alle SQL-Dateien testen / run all SQL files
```

Eine einzelne Folge / a single episode:
```bash
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/004/indexes.sql'
```

Mit einem SQL-Client verbinden / connect with any SQL client: `postgresql://app:<passwort>@localhost:5432/notes`

**Ohne Docker / without Docker** (z. B. `brew install postgresql@18`): `createdb notes`, dann `psql -d notes -f episodes/NNN/<datei>.sql`.
Für Folge 014 in `postgresql.conf` `shared_preload_libraries = 'pg_stat_statements'` setzen und den Server neu starten.

## Folgen / Episodes

| Nr. | Thema | Topic |
|---|---|---|
| [001](episodes/001/) | Warum PostgreSQL? Fünf Gründe | Why PostgreSQL? Five reasons |
| [002](episodes/002/) | PostgreSQL vs. MySQL: wann welches? | PostgreSQL vs. MySQL: which one when? |
| [003](episodes/003/) | JSONB: wann Tabellen nicht reichen | JSONB: when tables aren't enough |
| [004](episodes/004/) | Indexes: warum Datenbanken langsam werden | Indexes: why databases get slow |
| [005](episodes/005/) | Transaktionen: ACID einfach erklärt | Transactions: ACID explained |
| [006](episodes/006/) | PostgreSQL in Docker Compose | PostgreSQL in Docker Compose |
| [007](episodes/007/) | PostgreSQL und Spring Boot | PostgreSQL and Spring Boot |
| [008](episodes/008/) | PostgreSQL vs. MongoDB: SQL oder NoSQL? | PostgreSQL vs. MongoDB: SQL or NoSQL? |
| [009](episodes/009/) | Constraints: Datenintegrität in der Datenbank | Constraints: data integrity in the database |
| [010](episodes/010/) | MVCC und VACUUM | MVCC and VACUUM |
| [011](episodes/011/) | Migrationen mit Flyway | Migrations with Flyway |
| [012](episodes/012/) | Connection Pooling | Connection pooling |
| [013](episodes/013/) | Backup und Restore | Backup and restore |
| [014](episodes/014/) | Extensions: pgvector, PostGIS & Co. | Extensions: pgvector, PostGIS & co. |
| [015](episodes/015/) | CTEs und Window Functions | CTEs and window functions |

## Aufbau / Structure

```
compose.yaml          PostgreSQL 18 für die lokale Entwicklung (Folge 006) + optional pgvector (Folge 014)
.env.example          Vorlage für Zugangsdaten – die echte .env ist in .gitignore
scripts/run-all.sh    führt alle SQL-Dateien der Folgen im Container aus
episodes/NNN/         README + SQL pro Folge; 007 und 011 enthalten ein Spring-Boot-Projekt (app/)
```

Jede SQL-Datei arbeitet in einem eigenen Schema (`ep001`, `ep002`, …), räumt es am Anfang weg und ist beliebig oft ausführbar.
*Every SQL file uses its own schema (`ep001`, `ep002`, …), drops it at the start and can be re-run any time.*

## Hinweise / Notes

- **Nur für die lokale Entwicklung.** Das Compose-Setup ist kein Produktionsbetrieb (keine Backups, kein Monitoring, Passwort in `.env`). *Local development only.*
- Getestet mit / tested with: PostgreSQL 18.4, Spring Boot 4.1.1, Java 21. Zeiten und Größen in den READMEs stammen aus diesen Testläufen und weichen auf deinem Rechner ab.
- `mysql_8.4.sql` (002), `mongodb.js` (008) und `vector.sql` (014) laufen in eigenen Containern – Befehle stehen jeweils oben in der Datei.
