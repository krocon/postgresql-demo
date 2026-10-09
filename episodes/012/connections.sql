-- Folge 012 – Connection Pooling  ·  Episode 012
SHOW max_connections;                  -- 100 (Standard / default)
SHOW superuser_reserved_connections;   -- 3 davon für Superuser reserviert / reserved for superusers

-- Wer ist gerade verbunden? Jede Zeile = ein eigener Serverprozess (pid)
-- Who is connected right now? Every row = its own server process (pid)
SELECT pid, usename, application_name, state, backend_start
FROM pg_stat_activity
WHERE backend_type = 'client backend'
ORDER BY backend_start;

SELECT state, count(*) FROM pg_stat_activity
WHERE backend_type = 'client backend'
GROUP BY state;

-- Rechnung aus dem Video / the math from the video
SELECT 20 AS instances, 10 AS pool_size, 20 * 10 AS connections_needed,
       current_setting('max_connections')::int AS max_connections;
