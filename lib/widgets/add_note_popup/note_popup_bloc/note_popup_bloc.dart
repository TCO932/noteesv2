import 'dart:async';

import 'note_popup_events.dart';

class NotePopupBloc {
  final _notePopupStateController = StreamController<List<String>>.broadcast();
  StreamSink<List<String>> get _inNotePopup => _notePopupStateController.sink;
  Stream<List<String>> get notePopup => _notePopupStateController.stream;

  final _notePopupEventController = StreamController<NotePopupEvent>();
  Sink<NotePopupEvent> get notePopupEventSink => _notePopupEventController.sink;

  NotePopupBloc() {
    _notePopupEventController.stream.listen(_mapEventToState);
  }

  Future<void> _mapEventToState(NotePopupEvent event) async {
    if (event is NotePopupUpdateTags) {
      _inNotePopup.add(event.tags);
    } else if (event is NotePopupAddTag) {
      List<String> tags = await notePopup.last;
      _inNotePopup.add([...tags, event.tag]);
    }
  }

  void dispose() {
    _notePopupStateController.close();
    _notePopupEventController.close();
  }
}
