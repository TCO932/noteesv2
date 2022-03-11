import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tuple/tuple.dart';

import '../../entities/note.dart';
import '../add_note_popup/AddNotePopUp.dart';
import '../../widgets/NoteCard.dart';
import 'note_bloc/note_bloc.dart';
import 'note_bloc/note_event.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  final _noteBloc = NoteBloc();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? filterTag;
  bool isFilterTagInputOpened = false;
  final tagInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.box<Note>('notes');
    tagInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isFilterTagInputOpened) ...[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 100,
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                onChanged: (text) => widget._noteBloc.noteEventSink
                    .add(InitNoteListEvent.withTag(text.isEmpty ? null : text)),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9)),
                  hintText: 'Тег',
                ),
                style: Theme.of(context).textTheme.bodyText1,
                maxLines: 1,
                controller: tagInputController,
                autofocus: true,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                tagInputController.text = '';
                setState(() {
                  isFilterTagInputOpened = false;
                });
              },
            ),
          ] else
            IconButton(
              onPressed: () {
                setState(() {
                  isFilterTagInputOpened = true;
                });
              },
              icon: const Icon(Icons.filter_list_sharp),
            ),
        ],
        title: const Center(
          child: Text('Заметки'),
        ),
      ),
      floatingActionButton: addNoteButton(),
      body: StreamBuilder(
        initialData: initNoteList(),
        stream: widget._noteBloc.notes,
        builder: (BuildContext context,
            AsyncSnapshot<List<Tuple2<int, Note>>> snapshot) {
          if (snapshot.hasError) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('no data'),
              ],
            );
          }
          if (!snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('no data'),
              ],
            );
          }
          if (snapshot.data!.isEmpty) {
            return Container(
              child: Center(
                child: Text(
                  'Нет заметок.',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  onDismissed: (direction) => widget._noteBloc.noteEventSink
                      .add(DeleteNoteEvent(snapshot.data![index].item1)),
                  key: UniqueKey(),
                  child: GestureDetector(
                    onLongPress: () async {
                      Note? note = await addNotePopUp(
                          context, snapshot.data![index].item2);
                      if (note != null) {
                        widget._noteBloc.noteEventSink.add(
                          EditNoteEvent(snapshot.data![index].item1, note),
                        );
                      }
                    },
                    child: NoteCard(
                      note: snapshot.data![index].item2,
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  List<Tuple2<int, Note>> initNoteList() {
    widget._noteBloc.noteEventSink.add(InitNoteListEvent());
    return <Tuple2<int, Note>>[];
  }

  // Stream<List<Tuple2<int, Note>>> initNoteStream() {
  //   widget._noteBloc.noteEventSink.add(InitNoteListEvent());
  //   return widget._noteBloc.notes;
  // }

  FloatingActionButton addNoteButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        Note? note = await addNotePopUp(context, null);
        if (note != null) {
          widget._noteBloc.noteEventSink.add(CreateNoteEvent(note));
        }
      },
    );
  }
}
