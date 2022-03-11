import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entities/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;

  const NoteCard({Key? key, required this.note}) : super(key: key);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool isOpened = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpened = !isOpened;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Card(
          margin: const EdgeInsets.fromLTRB(8, 6, 8, 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: isOpened ? Curves.easeOutBack : Curves.easeInBack,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  style: isOpened ? BorderStyle.solid : BorderStyle.none,
                  width: 1.1,
                  color: Theme.of(context).primaryColor),
            ),
            child: noteInfo(context),
          ),
        ),
      ),
    );
  }

  Column noteInfo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInBack,
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: Text(
            widget.note.text,
            maxLines: isOpened ? null : 5,
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.fade,
          ),
        ),
        tags(context, widget.note.tags),
        const Divider(),
        if (isOpened) maximizedMeta(context) else minimizedMeta(context)
      ],
    );
  }

  List<Widget> tagsText(context, List<String> tags) {
    List<Widget> tagsWidgets = [];
    for (String tag in tags) {
      tagsWidgets.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(150),
                borderRadius: BorderRadius.circular(9)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Text(
                tag,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
    return tagsWidgets;
  }

  Widget tags(contex, List<String> tags) {
    if (tags.isEmpty) return Row();
    if (!isOpened) {
      return SizedBox(
        height: 25,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: tagsText(context, tags),
        ),
      );
    } else {
      return Wrap(
        children: tagsText(context, tags),
      );
    }
  }

  Row minimizedMeta(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 12, 10),
          child: Text(
            DateFormat('dd-MM-yyyy HH:mm').format(widget.note.editDate),
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  Row maximizedMeta(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // names
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 12, 5),
              child: Text(
                'Приоритет:',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 12, 5),
              child: Text(
                'Создано:',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 12, 10),
              child: Text(
                'Изменено:',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
        // data
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 12, 5),
              child: Text(
                widget.note.weight.toString(),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 12, 5),
              child: Text(
                DateFormat('dd-MM-yyyy HH:mm').format(widget.note.createDate),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 12, 10),
              child: Text(
                DateFormat('dd-MM-yyyy HH:mm').format(widget.note.editDate),
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        )
      ],
    );
  }
}
