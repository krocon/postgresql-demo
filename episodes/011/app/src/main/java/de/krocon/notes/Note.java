package de.krocon.notes;

import java.time.LocalDate;

/** Seit Migration V2 mit Fälligkeitsdatum (due_date → dueDate). */
public record Note(Long id, String text, LocalDate dueDate) {
}
