import 'package:rxdart/rxdart.dart';
//import 'package:collection/collection.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/resources/diy_resource/diy_resource_repository.dart';
import 'package:info_scanner_mobile/models/diy_resource.dart';

class DiyResourceBloc {
  final _diyResourceRepository = DiyResourceRepository();
  final _diyResourceFetcher = PublishSubject<List<DiyResource>>();

  StreamSink<List<DiyResource>> get inSink => _diyResourceFetcher.sink;
  Observable<List<DiyResource>> get allDiyResourcesStream => _diyResourceFetcher.stream;

  //constructor
  DiyResourceBloc() {
    
  }

  Future<List<DiyResource>> fetchAllDiyResources({@required int offset, @required int limit, String filter = ''}) async {
    List<DiyResource> projectList;
    try {
      projectList = await _diyResourceRepository.fetchAllDiyResources(offset: offset, limit: limit, filter: filter);
      inSink.add(projectList);
    } catch(err) {
      inSink.addError(err);
    }
    return projectList;
  }

  setInMyPalette(int diyResourceId, {bool val, String filter = ''}) async {
    await _diyResourceRepository.setInMyPalette(diyResourceId, val: val);
    fetchAllDiyResources(filter: filter);
  }

  dispose() async {
    await _diyResourceFetcher.drain();
    _diyResourceFetcher.close();
  }
}