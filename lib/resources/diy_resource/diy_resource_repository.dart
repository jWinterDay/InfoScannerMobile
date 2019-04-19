import 'dart:async';
import 'diy_resource_db_api_provider.dart';
import 'package:info_scanner_mobile/models/diy_resource.dart';

class DiyResourceRepository {
  final DiyResourceDbApiProvider _diyResourceProvider = new DiyResourceDbApiProvider();

  Future<List<DiyResource>> fetchAllDiyResources({int offset=0, int limit, String filter=''}) =>
    _diyResourceProvider.getDiyResources(offset: offset, limit: limit, filter: filter);

  setInMyPalette(int diyResourceId, {bool val}) => _diyResourceProvider.setInMyPalette(diyResourceId, val: val);
}