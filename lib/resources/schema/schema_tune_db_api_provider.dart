import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:info_scanner_mobile/resources/common_provider.dart';
import 'package:info_scanner_mobile/models/schema_settings/schema_tune.dart';
import 'package:info_scanner_mobile/Database.dart';// as database;


///Count list
class SchemaTuneDbApiProvider extends CommonProvider {
  //contructor
  SchemaTuneDbApiProvider() {
    //print('[SchemaTuneDbApiProvider contructor]');
  }
  SchemaTuneDbApiProvider.development() {
    //development logic here
    //print('[SchemaTuneDbApiProvider.development contructor]');
  }

  Future<List<SchemaTune>> getSchemaTuneList() async {
    Database db = await DBProvider.instance.database;

    var res = await db.query('schema_tune', orderBy: 'value');
    List<SchemaTune> list = res.isNotEmpty ? res.map((p) => SchemaTune.fromJson(p)).toList() : [];

    return list;
  }
}