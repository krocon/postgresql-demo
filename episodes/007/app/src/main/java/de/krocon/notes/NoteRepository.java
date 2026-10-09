package de.krocon.notes;

import java.util.List;
import java.util.Optional;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
class NoteRepository {
  private final JdbcClient jdbc;
  NoteRepository(JdbcClient jdbc) { this.jdbc = jdbc; }

  // Code aus dem Video / code from the video
  List<Note> findAll() {
    return jdbc.sql("SELECT * FROM notes").query(Note.class).list();
  }

  Optional<Note> findById(long id) {
    return jdbc.sql("SELECT id, text FROM notes WHERE id = ?")
        .param(id)
        .query(Note.class)
        .optional();
  }

  Note add(String text) {
    // RETURNING liefert die neue Zeile inklusive generierter id
    return jdbc.sql("INSERT INTO notes (text) VALUES (:text) RETURNING id, text")
        .param("text", text)
        .query(Note.class)
        .single();
  }
}
