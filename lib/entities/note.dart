import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String text;

  @HiveField(1)
  int weight;

  @HiveField(2)
  DateTime createDate;

  @HiveField(3)
  DateTime editDate;

  @HiveField(4)
  List<String> tags;

  Note(
      {required this.text,
      required this.weight,
      required this.createDate,
      required this.editDate,
      required this.tags});

  @override
  String toString() {
    return 'Note: $createDate';
  }

  int compare(Note a, Note b) {
    if (a.weight == b.weight) return 0;
    if (a.weight < b.weight) {
      return -1;
    } else {
      return 1;
    }
  }
}
