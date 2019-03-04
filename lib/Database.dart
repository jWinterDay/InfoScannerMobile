import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

//models
import 'package:info_scanner_mobile/Model/Project.dart';

class DBProvider {
  static Database _database;
  //static final DBProvider db = DBProvider._();

  //constructor
  //DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    return await initDB();
  }

  close() async {
    if (_database != null) {
      await _database.close();
    }
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'InfoScanner.db');

    print('initDB');
    //Database db;

    try {
      Database db = await openDatabase(
        path,
        version: _getVersion(),
        onCreate: _onCreate,
        onOpen: _onOpen,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
        onDowngrade: _onDowngrade
      );

      return db;
    } catch (err) {
      print('-------create db exception------');
      print(err);
      return null;
    }
  }

  int _getVersion() {
    return 11;
  }

  _onCreate (Database db, int version) async {
    print('onCreate');

    await db.execute(
      """create table project (
        project_id integer primary key autoincrement,
        name text,
        note text,
        begin_date integer,
        end_date integer,
        yooo integer)
      """
    );
  }

  _onUpgrade (Database db, int oldVersion, int newVersion) async {
    print('onUpgrade');
    // If you need to add a column
    if (newVersion > oldVersion) {
      await db.execute(
      """create table project (
        project_id integer primary key autoincrement,
        name text,
        note text,
        begin_date integer,
        end_date integer,
        yooo integer)
      """
      );
    }
  }

  _onOpen (Database db) async {
    print('onOpen');
  }

  _onDowngrade (Database db, int oldVersion, int newVersion) async {
    print('onDowngrade');
  }

  _onConfigure (Database db) async {
    print('onConfigure');
  }
}