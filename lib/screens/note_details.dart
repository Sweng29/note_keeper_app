import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper_app/dbConfig/database_helper.dart';
import 'package:note_keeper_app/models/note.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetails(this.note, this.appBarTitle);

  @override
  State createState() {
    return NoteDetailState(note, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetails> {
  static var _periorities = ['High', 'Low'];
  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton(
                    items: _periorities.map((String dropdownItem) {
                      return DropdownMenuItem<String>(
                        value: dropdownItem,
                        child: Text(dropdownItem),
                      );
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valueSelectedByUser) {
                      setState(() {
                        debugPrint(
                            'Value selected by User : $valueSelectedByUser');
                        updatePriorityAsInt(valueSelectedByUser);
                      });
                    },
                  ),
                ),
                // Second element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed by user in text field.');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // Third Element
                // Second element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed by user in text field.');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // Fourth element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            debugPrint('Save button clicked.');
                            _save();
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            debugPrint('Delete button clicked.');
                            delete();
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _periorities[0]; // High
        break;
      case 2:
        priority = _periorities[1];
        break;
    }
    return priority;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void delete() async {
    moveToLastScreen();
    if (note.id == null) {
      showAlertDialog('Status', 'No note was deleted');
      return;
    }

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      showAlertDialog('Status', 'Note was deleted successfully.');
    } else {
      showAlertDialog('Status', 'No note was deleted, try again.');
    }
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      showAlertDialog('Status', 'Note saved successfully.');
    } else {
      showAlertDialog('Status', 'Could not save note, try again.');
    }
  }

  showAlertDialog(String status, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(status),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
