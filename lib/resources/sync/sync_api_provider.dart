import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

import 'package:info_scanner_mobile/Database.dart';
import 'package:info_scanner_mobile/resources/common.dart';
import 'package:info_scanner_mobile/resources/project/project_db_api_provider.dart';

import 'package:info_scanner_mobile/models/project_model.dart';
import 'package:info_scanner_mobile/models/sync/sync_model.dart';


class SyncApiProvider {
  final Common _common = new Common();
  ProjectDbApiProvider projectDbApiProvider;
  final String host;

  SyncApiProvider(this.projectDbApiProvider, this.host);


  Future<SyncModel> syncAll() async {
    http.Response response;

    response = await _common.httpWrapper(host + '/sync');

    if (response.statusCode == 200) {
      final responseJSON = json.decode(response.body);
      final Iterable projectsJSON = responseJSON['rows'];

      List<Project> projectList = new List();
      projectList = projectsJSON.map((p) => projectFromJson(p)).toList();

      //synchronize with local database storage
      return await _syncWithLocal(projectList);
    }
    
    throw '${response.statusCode} ${response.body}';
  }

  Future<String> _doDbOperation({String lastOp, Project project, Transaction txn}) async {
    int res;

    //===DELETE===
    if (lastOp == 'D') {
      res = await projectDbApiProvider.syncDelete(project: project, transaction: txn);
      if (res > 0) return 'D';
    }

    //===UPDATE===
    res = await projectDbApiProvider.syncUpdate(project: project, transaction: txn);
    if (res > 0) return 'U';

    //===INSERT===
    res = await projectDbApiProvider.syncInsert(project: project, transaction: txn);
    if (res != null) return 'I';

    return null;
  }

  Future<SyncModel> _syncWithLocal(List<Project> projects) async {
    Database db = await DBProvider.instance.database;

    int delCnt = 0;
    int insCnt = 0;
    int updCnt = 0;
    String res = '';

    await db.transaction((txn) async {
      var batch = txn.batch();

      Iterable<Future<String>> operationList = projects.map((project) {
        return _doDbOperation(lastOp: project.lastOperation??'I', project: project, txn: txn);
      });

      Future
        .wait(operationList, eagerError: true)
        .then((list) {
          delCnt = list.where((p) => p == 'D').length;
          insCnt = list.where((p) => p == 'I').length;
          updCnt = list.where((p) => p == 'U').length;
        });

      await batch.commit(continueOnError: true, noResult: true);
    });

    res = 'projects(D: $delCnt, I: $insCnt, U: $updCnt)';

    return new SyncModel(message: res);
  }
}