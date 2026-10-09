package de.krocon.notes;

/** Eine Zeile der Tabelle notes – JdbcClient mappt die Spalten per Name auf die Record-Komponenten. */
public record Note(Long id, String text) {
}
