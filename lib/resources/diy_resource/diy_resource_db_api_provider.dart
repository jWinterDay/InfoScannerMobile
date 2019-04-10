import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/models/diy_resource.dart';
import 'package:info_scanner_mobile/Database.dart';// as database;

class DiyResourceDbApiProvider {

  //constructor
  DiyResourceDbApiProvider() {
    
  }

  Future<List<DiyResource>> getDiyResources([String filter = '']) async {
    //check for injection
    RegExp reg = RegExp(r"^(\w{0,5})$", caseSensitive: false);
    if(!reg.hasMatch(filter)) {
      return [];
    }

    Database db = await DBProvider.instance.database;

    String sql = 
      '''
      select q.*
        from (select dr.*,
                     case
                       when dr.no regexp '([[:digit:]])+' then 1
                       else 0
                     end as is_number
                from diy_resource dr
               where dr.no like '%$filter%') q
       order by case
                  when q.is_number = 1 then cast(q.no as int)
                  else -1
                end
      ''';
    var res = await db.rawQuery(sql);

    List<DiyResource> list = res.isNotEmpty ? res.map((p) => DiyResource.fromJson(p)).toList() : [];

    return list;
  }
}