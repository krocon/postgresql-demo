# Folge 005 – Transaktionen: ACID einfach erklärt
*Episode 005 – Transactions: ACID explained*

Code zur Folge 005 der Videoreihe **„PostgreSQL kompakt in 60 Sekunden“**. Alle Befehle aus dem Hauptordner des Repos.

## Inhalt
Überweisung mit `BEGIN`/`COMMIT`, `ROLLBACK`, eine am CHECK scheiternde Überweisung, die komplett verworfen wird; Isolationsebene (`default_transaction_isolation`), `REPEATABLE READ`, `synchronous_commit`.

## Ausführen / Run
```bash
docker compose up -d --wait
docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/005/transactions.sql'
```
Ohne Docker (z. B. Homebrew PostgreSQL 18) / without Docker:
```bash
psql -d notes -f episodes/005/transactions.sql
```

## Contents (English)
Bank transfer with `BEGIN`/`COMMIT`, `ROLLBACK`, a transfer failing the CHECK that is discarded completely; isolation level (`default_transaction_isolation`), `REPEATABLE READ`, `synchronous_commit`.

## Dateien / Files
- [`transactions.sql`](transactions.sql)

## Doku / Docs
- https://www.postgresql.org/docs/current/tutorial-transactions.html
- https://www.postgresql.org/docs/current/transaction-iso.html
