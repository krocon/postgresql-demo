CREATE TABLE notes (
  id   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  text text NOT NULL CHECK (btrim(text) <> '')
);
