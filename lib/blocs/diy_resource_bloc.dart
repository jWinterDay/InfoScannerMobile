import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/resources/diy_resource/diy_resource_repository.dart';
import 'package:info_scanner_mobile/models/diy_resource.dart';


class DiyResourceBloc {
  int _limit = 10;
  int _offset = 0;

  final DiyResourceRepository _diyResourceRepository = DiyResourceRepository();

  PublishSubject<String> _searchController;
  ValueConnectableObservable<String> _searchValObservable;

  PublishSubject<DiyResourceListState> _initController;
  PublishSubject<DiyResourceListState> _loadMoreController;
  PublishSubject<DiyResourceListState> _refreshController;
  PublishSubject<DiyResourceListState> _loadAllController;//if we loaded all data
  PublishSubject<DiyResourceListState> _errorController;//if we have got an error

  ValueConnectableObservable<DiyResourceListState> _lastValObservable;

  //public
  search(String value) {
    _searchController.sink.add(value);
  }

  Observable<DiyResourceListState> get list => _lastValObservable;
  loadFirst() {
    _initController.sink.add(null);
  }
  loadMore() {
    _loadMoreController.sink.add(null);
  }
  refresh() {
    _refreshController.sink.add(null);
  }
  
  //constructor
  DiyResourceBloc() {
    //search
    _searchController = new PublishSubject();
    _searchValObservable = _searchController.stream.publishValue();
    _searchValObservable
      .debounce(Duration(milliseconds: 300))
      .listen((d) async {
        print('[SEARCH] value = $d');
        refresh();
        _offset = 0;
      });

    //load data
    _initController = new PublishSubject();
    _loadMoreController = new PublishSubject();
    _refreshController = new PublishSubject();
    _loadAllController = new PublishSubject();
    _errorController = new PublishSubject();

    Observable<DiyResourceListState> _initObservable = _initController
      .map((p) => false)
      .flatMap(_load)
      .doOnData((d) {
        //print('[INIT] after flatMap data = $d');
      });
    Observable<DiyResourceListState> _loadMoreObservable = _loadMoreController
      .debounce(Duration(milliseconds: 300))
      .map((p) => false)
      .exhaustMap(_load)
      .doOnData((d) {
        //print('[LOAD MORE] after exhaustMap data = $d');
      });
    Observable<DiyResourceListState> _refreshObservable = _refreshController
      .map((p) => true)//refresh
      .flatMap(_load)
      .doOnData((d) {
        //print('[REFRESH] after flatMap data = $d');
      });

    //merged
    Observable<Observable<DiyResourceListState>> streams = Observable.merge([_initObservable, _loadMoreObservable, _refreshObservable])
      .doOnData((d) {
        //print('[MERGED] data = $d');
      })
      .map((p) => Observable.just(p));

    _lastValObservable = Observable
      .switchLatest(streams)
      .doOnData((data) {
        //print('[MERGED] switch latest data = $data');
      })
      .publishValue();


    _lastValObservable.connect();
    _searchValObservable.connect();
  }

  setInMyPalette(int diyResourceId, {bool val, String filter = ''}) async {

  }

  Stream<DiyResourceListState> _load(bool isRefresh) async* {
    final DiyResourceListState lastVal = _lastValObservable.value;

    if (lastVal == null) {
      yield null;
    } else {
      DiyResourceListState copiedState = lastVal.copyWith(isLoading: true);
      yield copiedState;
    }

    DiyResourceListState state;
    try {
      //TEST await Future.delayed(Duration(seconds: 2));
      String searchValue = _searchValObservable.value;
      List<DiyResource> list = await _diyResourceRepository.fetchAllDiyResources(offset: _offset, limit: _limit, filter: searchValue);
      if (lastVal == null || isRefresh) {
        state = new DiyResourceListState.initialList(list);
      } else {
        List<DiyResource> currentList = lastVal.list;
        currentList.addAll(list);
        state = new DiyResourceListState.initialList(currentList);
      }
    } catch(err) {
      state = new DiyResourceListState(error: err, isLoading: false, list: null);
    }

    _offset += _limit;

    yield state;
  }

  dispose() async {
    await _searchController.close();
    
    await _initController.close();
    await _refreshController.close();
    await _loadMoreController.close();
    await _loadAllController.close();
    await _errorController.close();
  }
}
