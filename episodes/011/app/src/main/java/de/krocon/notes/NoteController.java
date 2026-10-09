package de.krocon.notes;

import java.time.LocalDate;
import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/notes")
class NoteController {
  private final NoteRepository notes;
  NoteController(NoteRepository notes) { this.notes = notes; }

  @GetMapping
  List<Note> all() {
    return notes.findAll();
  }

  @GetMapping("/{id}")
  ResponseEntity<Note> one(@PathVariable long id) {
    return ResponseEntity.of(notes.findById(id));
  }

  record NewNote(String text, LocalDate dueDate) {}

  @PostMapping
  Note add(@RequestBody NewNote body) {
    return notes.add(body.text(), body.dueDate());
  }
}
