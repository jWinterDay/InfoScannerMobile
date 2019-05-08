import 'dart:async';

import 'schema_tune_db_api_provider.dart';
import 'schema_calc_method_db_api_provider.dart';

import 'package:info_scanner_mobile/models/schema_tune.dart';
import 'package:info_scanner_mobile/models/schema_calc_method.dart';


class SchemaRepository {
  final SchemaTuneDbApiProvider _schemaTuneProvider = new SchemaTuneDbApiProvider();
  final SchemaCalcMethodDbApiProvider _schemaCalcMethodProvider = new SchemaCalcMethodDbApiProvider();

  Future<List<SchemaTune>> getSchemaTuneList() => _schemaTuneProvider.getSchemaTuneList();
  Future<List<Method>> getSchemaMethodList() => _schemaCalcMethodProvider.getSchemaMethodList();
}