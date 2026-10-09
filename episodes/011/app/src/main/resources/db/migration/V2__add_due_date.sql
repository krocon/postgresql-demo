-- Code aus dem Video / code from the video
ALTER TABLE notes ADD COLUMN due_date date;
CREATE INDEX notes_due_date_idx ON notes (due_date);
