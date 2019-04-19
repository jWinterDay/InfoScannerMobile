import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/resources/diy_resource/diy_resource_repository.dart';
import 'package:info_scanner_mobile/models/diy_resource.dart';


class DiyResourceBloc {
  int get limit => 10;

  int _offset = 0;
  int get offset => _offset;
  set offset(offset) => _offset = offset;

  final _diyResourceRepository = DiyResourceRepository();

  DiyResourceListState _state = new DiyResourceListState.initial();
  PublishSubject<DiyResourceListState> _loadFirstPageController;
  PublishSubject<DiyResourceListState> _loadMoreController;

  Observable<DiyResourceListState> _listStream;//Observable.just(new DiyResourceListState.initial());
  Observable<DiyResourceListState> get listStream => _listStream;

  
  //constructor
  DiyResourceBloc() {
    //controllers
    _loadFirstPageController = new PublishSubject();
    _loadMoreController = new PublishSubject();

    //streams
    Observable firstPageStream = _loadFirstPageController.stream;
    Observable loadMoreStream =
      _loadMoreController.stream
      .debounce(Duration(milliseconds: 300));
      //.where((p) => p.error == null);

    _listStream =
      Observable
        .merge([firstPageStream, loadMoreStream])
        .map((p) {
          return _state.extendWith(p);
        });
  }

  initData({String filter = ''}) async {
    List<DiyResource> list;
    DiyResourceListState state = new DiyResourceListState(list: list, isLoading: true, error: null);

    try {
      list = await _diyResourceRepository.fetchAllDiyResources(limit: limit, filter: filter);
      state = new DiyResourceListState(list: list, isLoading: false, error: null);
      _loadFirstPageController.sink.add(state);
    } catch(err) {
      _loadFirstPageController.sink.add(new DiyResourceListState(error: err, isLoading: false, list: null));
      //_loadFirstPageController.sink.addError(err);
    }
    return state;
  }

  loadMoreResultData({String filter = ''}) async {
    offset += limit;
    List<DiyResource> list;
    DiyResourceListState state = new DiyResourceListState(error: null, list: null, isLoading: true,);
    _loadMoreController.sink.add(state);

    //await Future.delayed(Duration(seconds: 1));
    //state = new DiyResourceListState(error: 'exc', list: null, isLoading: false,);
    //_loadMoreController.sink.add(state);

    try {
      list = await _diyResourceRepository.fetchAllDiyResources(limit: 10, offset: offset);
      state = new DiyResourceListState(error: null, list: list, isLoading: false,);
      _loadMoreController.sink.add(state);
    } catch(err) {
      _loadFirstPageController.sink.add(new DiyResourceListState(error: err, list: null, isLoading: false,));
      //_loadMoreController.sink.addError(err);
    }
  }

  setInMyPalette(int diyResourceId, {bool val, String filter = ''}) async {

  }

  dispose() async {
    await _loadFirstPageController.drain();
    await _loadFirstPageController.close();
    await _loadMoreController.drain();
    await _loadMoreController.close();
  }
}
