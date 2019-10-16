import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:note_keeper_app/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton Database helper
  static Database _database;

  DatabaseHelper.createInstance();

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return noteDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = db.update(noteTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = db.delete(noteTable, where: '$colId=?', whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT(*) FROM $noteTable");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await this.getNoteMapList();
    var noteListSize = noteMapList.length;
    debugPrint('Note list size : $noteMapList');
    List<Note> noteList = List<Note>();
    for (int i = 0; i < noteListSize; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
