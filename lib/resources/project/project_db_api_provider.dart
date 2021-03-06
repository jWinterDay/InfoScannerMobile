import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/Database.dart';


class ProjectDbApiProvider {
  final String deviceId;

  ProjectDbApiProvider(this.deviceId);


  Future<List<Project>> getProjects() async {
    Database db = await DBProvider.instance.database;

    var res = await db.query('project', orderBy: 'project_id desc');
    List<Project> list = res.isNotEmpty ? res.map((p) => Project.fromMap(p)).toList() : [];

    //print('list = $list');

    return list;
  }

  Future<int> getProjectCount() async {
    Database db = await DBProvider.instance.database;

    List<Map<String, dynamic>> res = await db.rawQuery(
      """
      select count(1) as cnt
        from project
       where begin_end_date is null
      """
    );

    return res.first['cnt'];
  }
  
  newProject(Project project) async {
    Database db = await DBProvider.instance.database;

    int dt = project.unixBeginDate ?? DateTime.now().millisecondsSinceEpoch;
    String name = project.name;

    if (name == null) {
      int cnt = await getProjectCount();
      name = 'new project ($cnt)';
    }

    int lastId = await db.rawInsert(
      """
      insert into project(name, note, unix_begin_date, device_guid, is_own_project, last_operation)
      values(?, ?, ?, ?, 1, 'I');
      """,
      [name, project.note, dt, deviceId]
    );

    return lastId;
  }

  udpateProject(Project project) async {
    Database db = await DBProvider.instance.database;
    int curDate = DateTime.now().millisecondsSinceEpoch;

    var res = await db.rawUpdate(
      """
      update project
          set name = ?,
              note = ?,
              unix_end_date = ?,
              last_operation = 'U',
              unix_last_change_date = ?
        where project_id = ?;
      """,
      [project.name, project.note, project.unixEndDate, curDate, project.projectId]
    );

    return res;
  }

  preDeleteProject(Project project) async {
    Database db = await DBProvider.instance.database;
    int endDate = DateTime.now().millisecondsSinceEpoch;

    return await db.rawDelete(
      """
      update project
         set unix_end_date = ?
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
         set unix_end_date = null
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
    //Database db = await DBProvider.instance.database;

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

  //===========sync===========
  Future<int> syncDelete({@required Project project, @required Transaction transaction}) async {
    return transaction.delete('project', where: 'project_guid', whereArgs: [project.projectGuid]);
  }

  Future<int> syncInsert({@required Project project, @required Transaction transaction}) async {
    int unixCurTime = DateTime.now().millisecondsSinceEpoch;
    
    int lastId = await transaction.rawInsert(
      '''
        insert into project(name, unix_begin_date, note,
                            project_guid, device_guid, unix_sync_date,
                            sync_device_guid, is_own_project, last_operation)
        select ?, ?, ?,
               ?, ?, ?,
               ?, ?, ?
         where not exists(select 1 from project where project_guid = ?)
      ''',

      //where not exists(select 1 from project where project_guid = ?)
      [
        project.name,
        project.unixBeginDate * 1000,//on the server date presents as seconds
        project.note,

        project.projectGuid,
        project.deviceGuid ?? 'Unknown device',
        unixCurTime,

        project.deviceGuid,
        project.isOwnProject,
        'I',
        project.projectGuid,
      ]
    );

    return lastId;
  }

  Future<int> syncUpdate({@required Project project, @required Transaction transaction}) async {
    int unixCurTime = DateTime.now().millisecondsSinceEpoch;
    
    return await transaction.rawUpdate(
      '''
        update project
           set name = ?,
               note = ?,
               unix_sync_date = ?,
               is_own_project = ?,
               last_operation = ?,
               unix_last_change_date = ?
         where project_guid = ?
      ''',
      [
        project.name,
        project.note,
        unixCurTime,
        project.isOwnProject,
        'U',
        unixCurTime,
        project.projectGuid
      ]
    );
  }

  Future<int> syncUpsert({@required Project project, @required Transaction transaction, @required String lastOp}) async {
    int unixCurTime = DateTime.now().millisecondsSinceEpoch;
    int lastId;

    int updCount = await transaction.rawUpdate(
      '''
        update project
           set name = ?,
               note = ?,
               unix_sync_date = ?,
               is_own_project = ?,
               last_operation = ?
         where project_guid = ?
      ''',
      [
        project.name,
        project.note,
        unixCurTime,
        project.isOwnProject,
        lastOp,
        project.projectGuid
      ]
    );

    if (updCount == 0) {
      lastId = await transaction.rawInsert(
        '''
          insert into project(name, unix_begin_date, note,
                              project_guid, device_guid, unix_sync_date,
                              sync_device_guid, is_own_project, last_operation)
          values (?, ?, ?,
                  ?, ?, ?,
                  ?, ?, ?)
        ''',
        [
          project.name,
          project.unixBeginDate * 1000,//on the server date presents as seconds
          project.note,

          project.projectGuid,
          project.deviceGuid ?? 'Unknown device',
          unixCurTime,

          project.deviceGuid,
          project.isOwnProject,
          lastOp
        ]
      );
    }

    return lastId;
  }
}