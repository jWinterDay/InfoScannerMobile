import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'dart:async';

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

  Future<List<DiyResource>> fetchAllDiyResources([String filter = '']) async {
    List<DiyResource> projectList = await _diyResourceRepository.fetchAllDiyResources(filter);
    inSink.add(projectList);
    return projectList;
  }

  dispose() async {
    await _diyResourceFetcher.drain();
    _diyResourceFetcher.close();
  }
}