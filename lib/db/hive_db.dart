import 'package:hive_flutter/hive_flutter.dart';
import 'package:tuple/tuple.dart';

import '../entities/note.dart';

class HiveDB {
  final _box = Hive.box<Note>('notes');
  // TODO add tag filter
  List<Tuple2<int, Note>> getNoteList({String? tag}) {
    List<Tuple2<int, Note>> noteList = [];
    if (tag != null) {
      _box.toMap().forEach((key, value) {
        if (value.tags.contains(tag)) {
          noteList.add(Tuple2<int, Note>(key, value));
        }
      });
    } else {
      _box.toMap().forEach((key, value) {
        noteList.add(Tuple2<int, Note>(key, value));
      });
    }
    return noteList..sort((a, b) => b.item2.weight - a.item2.weight);
  }

  void addNote(Note note) async {
    await _box.add(note);
  }

  void editNote(int key, Note note) async {
    await _box.put(key, note);
  }

  void deleteNote(int key) async => await _box.delete(key);

  void close() => _box.close();
}
