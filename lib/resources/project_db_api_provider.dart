import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/Database.dart';// as database;

import 'package:sqflite/sqflite.dart';

class ProjectDbApiProvider {
  //Future<Project>
  Future<List<Project>> getProjects() async {
    Database db = await DBProvider.instance.database;

    var res = await db.query('project', where: 'end_date is null', orderBy: 'begin_date desc');
    List<Project> list = res.isNotEmpty ? res.map((p) => Project.fromMap(p)).toList() : [];

    return list;
  }
  
  newProject(Project project) async {
    Database db = await DBProvider.instance.database;

    int res = await db.rawInsert(
      """
      insert into project(name, note)
      values(?, ?);
      """,
      [project.name, project.note]
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

  deleteProject(Project project) async {
    Database db = await DBProvider.instance.database;

    var res = await db.rawDelete(
      """
      delete from project
        where project_id = ?;
      """,
      [project.projectId]
    );

    return res;
  }

  deleteAllProjects() async {
    Database db = await DBProvider.instance.database;

    var res = await db.rawDelete(
      """
      delete from project;
      """
    );

    return res;
  }
}