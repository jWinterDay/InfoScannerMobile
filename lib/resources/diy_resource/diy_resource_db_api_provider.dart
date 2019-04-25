import 'package:sqflite/sqflite.dart';

import 'package:info_scanner_mobile/models/diy_resource.dart';
import 'package:info_scanner_mobile/Database.dart';// as database;
import 'package:info_scanner_mobile/resources/common.dart';
import 'package:info_scanner_mobile/models/logged_user_info.dart';

class DiyResourceDbApiProvider {
  Common _common = new Common();

  //constructor
  DiyResourceDbApiProvider() {
    
  }

  Future<List<DiyResource>> getDiyResources({int offset=0, int limit, String filter = ''}) async {
    //check for injection
    RegExp reg = RegExp(r"^(\w{0,5})$", caseSensitive: false);
    if(!reg.hasMatch(filter??'')) {
      return [];
    }

    print('limit = $limit, offset = $offset, filter = $filter');

    Database db = await DBProvider.instance.database;

    String sql =
      '''
      select diy_resource_id,
             name,
             no,
             color,
             lab,
             hsl,
             amount_type_id,
             users_diy_resource_id,
             amount_type_name,
             amount_type_note,
             in_my_palette               
        from (select dr.*,
                     udr.amount_type_id,
                     udr.users_diy_resource_id,
                     case
                       when udr.users_diy_resource_id is null then 0
                       else 1
                     end as in_my_palette,
                     at.name as amount_type_name,
                     at.note as amount_type_note
                from diy_resource dr
                left join users_diy_resource udr on udr.diy_resource_id = dr.diy_resource_id
                left join amount_type at on at.amount_type_id = udr.amount_type_id
               where dr.no like '%${filter??''}%'
               order by udr.users_diy_resource_id desc,
                        case
                          when dr.no regexp '([[:digit:]])+' then 1
                          else 0
                        end
               limit ${limit??1000} offset ${offset??0}
              ) q
      ''';
    var res = await db.rawQuery(sql);
    //print('sql res = $res');
    List<DiyResource> list = res.isNotEmpty ? res.map((p) => DiyResource.fromJson(p)).toList() : [];
    return list;
  }

  Future<List<DiyResource>> getDiyResource(int diyResourceId) async {
    Database db = await DBProvider.instance.database;

    String sql =
      '''
      select diy_resource_id,
             name,
             no,
             color,
             lab,
             hsl,
             amount_type_id,
             users_diy_resource_id,
             amount_type_name,
             amount_type_note,
             in_my_palette               
        from (select dr.*,
                     udr.amount_type_id,
                     udr.users_diy_resource_id,
                     case
                       when udr.users_diy_resource_id is null then 0
                       else 1
                     end as in_my_palette,
                     at.name as amount_type_name,
                     at.note as amount_type_note
                from diy_resource dr
                left join users_diy_resource udr on udr.diy_resource_id = dr.diy_resource_id
                left join amount_type at on at.amount_type_id = udr.amount_type_id
               where dr.diy_resource_id = $diyResourceId
              ) q
      ''';
    var res = await db.rawQuery(sql);

    List<DiyResource> list = res.isNotEmpty ? res.map((p) => DiyResource.fromJson(p)).toList() : [];
    return list;
  }

  setInMyPalette(DiyResource diyResource, {bool val}) async {
    Database db = await DBProvider.instance.database;
    LoggedUserInfo user = await _common.getUserLocal();

    String sql;

    //val - next checkbox value
    if (val) {
      sql =
        '''
        insert into users_diy_resource(amount_type_id, diy_resource_id, user_id)
        values(3, ?, ?)
        ''';
        db.execute(sql, [diyResource.diyResourceId, user?.userId]);
    } else {
      sql =
        '''
        delete from users_diy_resource where diy_resource_id = ?
        ''';
        db.execute(sql, [diyResource.diyResourceId]);
    }

    //return
    return getDiyResource(diyResource.diyResourceId);
  }
}