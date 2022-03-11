import 'package:noteesv2/entities/note.dart';

abstract class NoteEvent {}

class CreateNoteEvent extends NoteEvent {
  final Note note;

  CreateNoteEvent(this.note);
}

class InitNoteListEvent extends NoteEvent {
  String? tag;

  InitNoteListEvent();
  InitNoteListEvent.withTag(this.tag);
}

class EditNoteEvent extends NoteEvent {
  final int key;
  final Note note;

  EditNoteEvent(
    this.key,
    this.note,
  );
}

class DeleteNoteEvent extends NoteEvent {
  final int key;

  DeleteNoteEvent(this.key);
}
