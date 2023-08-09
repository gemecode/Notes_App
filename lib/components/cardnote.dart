import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/constant/linkapi.dart';
import 'package:notes_app/model/notemodel.dart';

class CardNotes extends StatelessWidget {
  final void Function() onTap;
  final NoteModel noteModel;
  final void Function()? onDelete;
  const CardNotes(
      {Key? key, required this.onTap, this.onDelete, required this.noteModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Image.network(
                  "$linkImageRoot/${noteModel.notesImage}",
                  width: 100,
                  height: 100,
                  // fit: BoxFit.fill,
                )),
            Expanded(
                flex: 2,
                child: ListTile(
                  title: Text("${noteModel.notesTitle}"),
                  subtitle: Text("${noteModel.notesContent}"),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete), onPressed: onDelete),
                )),
          ],
        ),
      ),
    );
  }
}
