import 'package:sqflite/sqflite.dart' as sqlflite;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';


class DBProvider {
  static sqlflite.Database _database;

  static final DBProvider instance = DBProvider._();

  //constructor
  DBProvider._();

  Future<sqlflite.Database> get database async {
    if (_database != null) {
      if (!_database.isOpen) {
        assert(!_database.isOpen, 'ProjectDAO.getProjects. Db is closed');
        DBProvider._database = await open();
      }

      return _database;
    }

    DBProvider._database = await open();
    return DBProvider._database;
  }

  close() async {
    print('DATABASE. close');
    if (_database != null) {
      await _database.close();
    }
  }

  open() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'InfoScanner.db');

    print('DATABASE. open');
    //Database db;

    try {
      sqlflite.Database db = await sqlflite.openDatabase(
        path,
        version: 19,
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

  _onCreate (sqlflite.Database db, int version) async {
    print('DATABASE. onCreate');

    await db.execute(
      """create table project (
        project_id integer primary key autoincrement,
        name text,
        note text,
        begin_date integer default (CURRENT_TIMESTAMP),
        end_date integer,
        project_guid text default (hex(randomblob(16))))
      """
    );
  }

  _onUpgrade (sqlflite.Database db, int oldVersion, int newVersion) async {
    print('DATABASE. onUpgrade');

    if (newVersion > oldVersion) {
      print('begin upgrade database....newV: $newVersion, oldV: $oldVersion');

      await db.execute(
        """create table project (
          project_id integer primary key autoincrement,
          name text,
          note text,
          begin_date integer,
          end_date integer,
          project_guid text default (hex(randomblob(16))));
        """
      );
    }
  }

  _onOpen (sqlflite.Database db) async {
    print('DATABASE. onOpen');
  }

  _onDowngrade (sqlflite.Database db, int oldVersion, int newVersion) async {
    print('DATABASE. onDowngrade');
  }

  _onConfigure (sqlflite.Database db) async {
    print('DATABASE. onConfigure');
  }
}