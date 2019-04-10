import 'dart:async';
import 'diy_resource_db_api_provider.dart';
import 'package:info_scanner_mobile/models/diy_resource.dart';

class DiyResourceRepository {
  final DiyResourceDbApiProvider _diyResourceProvider = new DiyResourceDbApiProvider();


  Future<List<DiyResource>> fetchAllDiyResources([String filter]) => _diyResourceProvider.getDiyResources(filter);
}