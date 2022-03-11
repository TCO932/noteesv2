import 'dart:async';

import 'package:tuple/tuple.dart';

import '../../../db/hive_db.dart';
import '../../../entities/note.dart';
import 'note_event.dart';

class NoteBloc {
  final _db = HiveDB();

  final _noteStateController = StreamController<List<Tuple2<int, Note>>>();
  StreamSink<List<Tuple2<int, Note>>> get _inNotes => _noteStateController.sink;
  Stream<List<Tuple2<int, Note>>> get notes => _noteStateController.stream;

  final _noteEventController = StreamController<NoteEvent>();
  Sink<NoteEvent> get noteEventSink => _noteEventController.sink;

  NoteBloc() {
    _noteEventController.stream.listen(_mapEventToState);
  }

  Future<void> _mapEventToState(NoteEvent event) async {
    if (event is CreateNoteEvent) {
      _db.addNote(event.note);
      _inNotes.add(_db.getNoteList());
    } else if (event is EditNoteEvent) {
      _db.editNote(event.key, event.note);
      _inNotes.add(_db.getNoteList());
    } else if (event is DeleteNoteEvent) {
      _db.deleteNote(event.key);
      _inNotes.add(_db.getNoteList());
    } else if (event is InitNoteListEvent) {
      _inNotes.add(_db.getNoteList(tag: event.tag));
    }
  }

  void dispose() {
    _db.close();
    _noteEventController.close();
    _noteStateController.close();
  }
}
