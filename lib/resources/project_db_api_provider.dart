import 'package:sqflite/sqflite.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/Database.dart';// as database;
import 'package:device_id/device_id.dart';

class ProjectDbApiProvider {
  String _deviceId = 'Unknown';

  //constructor
  ProjectDbApiProvider() {
    initDeviceId();
  }

  Future<void> initDeviceId() async {
    try {
      _deviceId = await DeviceId.getID;
    } catch(err) {

    }
  }

  Future<List<Project>> getProjects() async {
    Database db = await DBProvider.instance.database;

    //var res = await db.query('project', where: 'end_date is null', orderBy: 'begin_date desc');
    var res = await db.query('project', orderBy: 'begin_date desc');
    List<Project> list = res.isNotEmpty ? res.map((p) => Project.fromMap(p)).toList() : [];

    return list;
  }

  Future<int> getProjectCount() async {
    Database db = await DBProvider.instance.database;

    List<Map<String, dynamic>> res = await db.rawQuery(
      """
      select count(1) as cnt
        from project
       where end_date is null
      """
    );

    return res.first['cnt'];
  }
  
  newProject(Project project) async {
    Database db = await DBProvider.instance.database;

    int dt = project.beginDate ?? DateTime.now().millisecondsSinceEpoch;
    String name = project.name;

    //_deviceId = await DeviceId.getID;
    //String deviceGuid = await DeviceId.getID;

    if (name == null) {
      int cnt = await getProjectCount();
      name = 'new project ($cnt)';
    }

    int res = await db.rawInsert(
      """
      insert into project(name, note, begin_date, device_guid)
      values(?, ?, ?, ?);
      """,
      [name, project.note, dt, _deviceId]
    );

    return res;
  }

  udpateProject(Project project) async {
    Database db = await DBProvider.instance.database;

    var res = await db.rawUpdate(
      """
      update project
          set name = ?,
              note = ?,
              end_date = ?
        where project_id = ?;
      """,
      [project.name, project.note, project.endDate, project.projectId]
    );

    return res;
  }

  preDeleteProject(Project project) async {
    Database db = await DBProvider.instance.database;
    int endDate = DateTime.now().millisecondsSinceEpoch;

    return await db.rawDelete(
      """
      update project
         set end_date = ?
        where project_id = ?;
      """,
      [endDate, project.projectId]
    );
  }

  deleteProject(Project project) async {
    Database db = await DBProvider.instance.database;

    return await db.rawDelete(
      """
      delete from project
        where project_id = ?;
      """,
      [project.projectId]
    );
  }

  restoreProject(Project project) async {
    Database db = await DBProvider.instance.database;

    return await db.rawDelete(
      """
      update project
         set end_date = null
        where project_id = ?;
      """,
      [project.projectId]
    );
  }

  deleteAllProjects() async {
    Database db = await DBProvider.instance.database;

    return await db.rawDelete(
      """
      delete from project;
      """
    );
  }

  Future<bool> isCanDeleteProject(Project project) async {
    Database db = await DBProvider.instance.database;

    /*List<Map<String, dynamic>> res = await db.rawQuery(
      """
      select count(1) + 1 as cnt
        from project
       where end_date is null
      """
    );*/

    //return res.first['cnt'];
    return true;
  }
}