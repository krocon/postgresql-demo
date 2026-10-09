-- Folge 014 – pgvector. Braucht den Service "vector" (Image pgvector/pgvector:pg18):
--   docker compose --profile vector up -d vector
--   docker compose exec -T vector sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /episodes/014/vector.sql'
SET client_min_messages = warning;   -- „schema … does not exist, skipping“ ausblenden
DROP SCHEMA IF EXISTS ep014v CASCADE;
RESET client_min_messages;
CREATE SCHEMA ep014v;
SET search_path = ep014v;

-- Code aus dem Video / code from the video (3 Dimensionen zum Anschauen; echte Embeddings haben Hunderte)
CREATE EXTENSION IF NOT EXISTS vector;
CREATE TABLE docs (id bigint PRIMARY KEY, embedding vector(3));
CREATE INDEX ON docs USING hnsw (embedding vector_cosine_ops);

INSERT INTO docs VALUES
  (1, '[0.1, 0.2, 0.3]'),
  (2, '[0.2, 0.1, 0.4]'),
  (3, '[0.9, 0.8, 0.1]'),
  (4, '[-0.5, 0.3, 0.2]');

-- <=> = Kosinus-Distanz, kleiner = ähnlicher / cosine distance, smaller = more similar
SELECT id, embedding <=> '[0.1, 0.2, 0.3]' AS distance
FROM docs ORDER BY embedding <=> '[0.1, 0.2, 0.3]' LIMIT 5;
