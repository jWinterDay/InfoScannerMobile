import 'package:info_scanner_mobile/Model/Project.dart';
import 'package:info_scanner_mobile/Database.dart';// as database;

import 'package:sqflite/sqflite.dart';

newProject(Project newProject) async {
  Database database;
  DBProvider provider;
  try {
    provider = new DBProvider();
    database = await provider.database;

    //var db = await DBProvider.db;//.database;
    //var res = await database.rawInsert(
    //  "insert into project (name)"
    //  "values ('${newProject.name}')");//, '${newProject.name}', '${newProject.note}')");


    //var res = await database.getVersion();

    //print(res);

    var sel = await database.rawQuery('select * from project');

    print(sel);
  } catch(err) {
    print('----------exception-----------');
    print(err);
  } finally {
      database.close();
  }

  //var res = await DBProvider.db.database.then((d) => {
  //  d.getVersion()
    //print(await d.getVersion())
  //});//. database. rawInsert(
  
    //"INSERT Into Client (id,first_name)"
    //" VALUES (${newClient.id},${newClient.firstName})");
  return null;//res;
}