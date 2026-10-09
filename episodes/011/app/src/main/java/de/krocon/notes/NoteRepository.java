package de.krocon.notes;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
class NoteRepository {
  private final JdbcClient jdbc;
  NoteRepository(JdbcClient jdbc) { this.jdbc = jdbc; }

  List<Note> findAll() {
    return jdbc.sql("SELECT * FROM notes").query(Note.class).list();
  }

  Optional<Note> findById(long id) {
    return jdbc.sql("SELECT id, text, due_date FROM notes WHERE id = ?")
        .param(id)
        .query(Note.class)
        .optional();
  }

  Note add(String text, LocalDate dueDate) {
    // RETURNING liefert die neue Zeile inklusive generierter id
    return jdbc.sql("INSERT INTO notes (text, due_date) VALUES (:text, :dueDate) RETURNING id, text, due_date")
        .param("text", text)
        .param("dueDate", dueDate)
        .query(Note.class)
        .single();
  }
}
