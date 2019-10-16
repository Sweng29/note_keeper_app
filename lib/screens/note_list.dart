import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper_app/dbConfig/database_helper.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:note_keeper_app/screens/note_details.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  var count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetails(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                deleteNote(context, noteList[position]);
              },
            ),
            onTap: () {
              debugPrint('Dummy note clicked');
              navigateToDetails(this.noteList[position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.keyboard_arrow_right);
        break;
      case 2:
        return Icon(Icons.play_arrow);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void deleteNote(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted successfully.');
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((datatbase) {
      Future<List<Note>> futureNoteList = databaseHelper.getNoteList();
      futureNoteList.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void navigateToDetails(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetails(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }
}
