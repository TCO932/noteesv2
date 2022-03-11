import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteesv2/widgets/add_note_popup/note_popup_bloc/note_popup_events.dart';

import '../../entities/note.dart';
import 'note_popup_bloc/note_popup_bloc.dart';

//  TODO ANOTHER BLOC?
Future<Note?> addNotePopUp(BuildContext context, Note? oldNote) {
  return showDialog<Note>(
    context: context,
    builder: (BuildContext context) => AddNoteWidget(
      note: oldNote ??
          Note(
            text: '',
            weight: 1,
            createDate: DateTime.now(),
            editDate: DateTime.now(),
            tags: [],
          ),
    ),
  );
}

class AddNoteWidget extends StatefulWidget {
  Note note;

  AddNoteWidget({Key? key, required this.note}) : super(key: key);

  @override
  _AddNoteWidgetState createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> {
  final textInputController = TextEditingController();
  final weightInputController = TextEditingController();
  final tagInputController = TextEditingController();
  final _bloc = NotePopupBloc();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    tags = widget.note.tags;
  }

  @override
  void dispose() {
    super.dispose();
    textInputController.dispose();
    weightInputController.dispose();
    tagInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textInputController.text = widget.note.text;
    weightInputController.text = widget.note.weight.toString();
    Note newNote;
    return AlertDialog(
      scrollable: true,
      backgroundColor: Theme.of(context).primaryColorLight,
      title:
          Text('Новая заметка', style: Theme.of(context).textTheme.headline1),
      content: IntrinsicHeight(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Текст',
              ),
              style: Theme.of(context).textTheme.bodyText1,
              maxLines: 2,
              controller: textInputController,
              autofocus: true,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Приоритет',
              ),
              style: Theme.of(context).textTheme.bodyText1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              controller: weightInputController,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Тег',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _bloc.notePopupEventSink.add(NotePopupUpdateTags(
                        tags..add(tagInputController.text)));
                    tagInputController.text = '';
                  },
                ),
              ),
              style: Theme.of(context).textTheme.bodyText1,
              controller: tagInputController,
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: StreamBuilder(
                initialData: tags,
                stream: _bloc.notePopup,
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container();
                  } else {
                    return Wrap(
                      children: [
                        for (String tag in snapshot.data!)
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 1, vertical: 1),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(150),
                                  borderRadius: BorderRadius.circular(9)),
                              child: SizedBox(
                                height: 30,
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(right: 5),
                                  ),
                                  icon: const Icon(Icons.remove),
                                  label: Text(
                                    tag,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => _bloc.notePopupEventSink.add(
                                      NotePopupUpdateTags(tags..remove(tag))),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () => {
            newNote = Note(
              text: textInputController.text,
              weight: int.parse(weightInputController.text),
              createDate: widget.note.createDate,
              editDate: DateTime.now(),
              tags: tags,
            ), // TODO add new tags
            Navigator.pop(context, newNote),
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}

// List<Widget> tagsBuilder(
//   context,
//   List<String> tags,
//   Widget setState,
// ) {
//   List<Widget> tagsWidgets = [];
//   for (String tag in tags) {
//     tagsWidgets.add(
//       Container(
//         margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor.withAlpha(150),
//               borderRadius: BorderRadius.circular(9)),
//           child: SizedBox(
//             height: 30,
//             child: TextButton(
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.zero,
//               ),
//               child: Text(
//                 tag,
//                 style: const TextStyle(color: Colors.white),
//               ),
//               onPressed: setState(() => tags.remove(tag)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   return tagsWidgets;
// }
