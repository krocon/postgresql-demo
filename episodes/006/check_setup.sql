-- Folge 006 – PostgreSQL in Docker Compose  ·  Episode 006
-- Prüft das laufende Setup aus compose.yaml. / Checks the running setup from compose.yaml.
SELECT version();
SHOW data_directory;      -- im Container / in the container: /var/lib/postgresql/18/docker
SHOW listen_addresses;    -- '*' im Container – nach außen begrenzt der Port 127.0.0.1:5432
SELECT current_user, current_database();
