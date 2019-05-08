import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/models/schema_calc_method.dart';
import 'package:info_scanner_mobile/Database.dart';// as database;


///Calculate method
class SchemaCalcMethodDbApiProvider {
  Future<List<Method>> getSchemaMethodList() async {
    List<Method> methods = List.of([
      new Method(methodId: 1, name: 'Compress', paramList: [
        new Param(name: 'Compress', paramId: 1, value: 11, hint: 'Value'),
      ]),
      new Method(methodId: 2, name: 'Width/Height, mm', paramList: [
        new Param(name: 'Width', paramId: 2, value: 12, hint: 'Width'),
        new Param(name: 'Height', paramId: 3, value: 13, hint: 'Height')
      ])
    ]);

    return methods;
  }
}