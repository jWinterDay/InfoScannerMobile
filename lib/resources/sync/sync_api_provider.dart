import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import 'package:info_scanner_mobile/Database.dart';// as database;
import 'package:info_scanner_mobile/resources/common.dart';
import 'package:info_scanner_mobile/resources/project/project_db_api_provider.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/models/sync_model.dart';

final String syncAllUrl = 'http://192.168.1.42:3001/project/ajax/list';

class SyncApiProvider {
  final Common _common = new Common();

  //http sync
  Future<SyncModel> syncAll() async {
    http.Response response = await _common.httpWrapper(syncAllUrl);

    if (response.statusCode == 200) {
      final responseJSON = json.decode(response.body);
      final Iterable projectsJSON = responseJSON['rows'];

      List<Project> projectList = new List();
      projectList = projectsJSON.map((p) => projectFromJson(p)).toList();

      //print('projectList: $projectList');

      //synchronize with local database storage
      await syncWithLocal(projectList);

      return new SyncModel(message: 'received ${projectList.length} projects from server');
    }
    
    throw '${response.statusCode} ${response.body}';
  }

  Future syncWithLocal(List<Project> projects) async {
    Database db = await DBProvider.instance.database;
    ProjectDbApiProvider projectDbApiProvider = new ProjectDbApiProvider();

    await db.transaction((txn) async {
      var batch = txn.batch();

      projects.forEach((project) async {
        String lastOp = project.lastOperation ?? 'I';

        //===DELETE===
        if (lastOp == 'D') {
          await projectDbApiProvider.syncDelete(project: project, transaction: txn);
        }

        //===INSERT or UPDATE===
        if (['I', 'U'].contains(lastOp)) {
          await projectDbApiProvider.syncUpsert(project: project, lastOp: lastOp, transaction: txn);
        }
        
        await batch.commit(continueOnError: true, noResult: true);
      });
    });
  }
}