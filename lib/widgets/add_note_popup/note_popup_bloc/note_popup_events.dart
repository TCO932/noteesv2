abstract class NotePopupEvent {}

class NotePopupUpdateTags extends NotePopupEvent {
  final List<String> tags;

  NotePopupUpdateTags(this.tags);
}

class NotePopupAddTag extends NotePopupEvent {
  final String tag;

  NotePopupAddTag(this.tag);
}
