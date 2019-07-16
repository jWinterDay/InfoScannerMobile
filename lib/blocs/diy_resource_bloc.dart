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
  PublishSubject<DiyResourceListState> _reinitController;
  PublishSubject<List<DiyResource>> _refreshRowsController;
  PublishSubject<bool> _loadedAllController;
  PublishSubject<DiyResourceListState> _errorController;//if we have got an error

  ValueConnectableObservable<DiyResourceListState> _lastValObservable;
  ValueConnectableObservable<bool> _lastIsLoadedAllObservable;

  //public
  Observable<DiyResourceListState> get list => _lastValObservable;
  Observable<bool> get isLoadedAll => _lastIsLoadedAllObservable;

  search(String value) {
    _searchController.sink.add(value);
  }
  loadFirst() {
    _initController.sink.add(null);
  }
  loadMore() {
    _loadMoreController.sink.add(null);
  }
  setInMyPalette(DiyResource diyResource, {bool val, String filter = ''}) async {
    List<DiyResource> list = await _diyResourceRepository.setInMyPalette(diyResource, val: val);
    if (list == null) return;

    _refreshRowsController.sink.add(list);
  }
  
  //constructor
  DiyResourceBloc() {
    //search
    _searchController = new PublishSubject();
    _searchValObservable = _searchController.stream.publishValue();
    _searchValObservable
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 300)))
      .listen((d) async {
        //print('[SEARCH] value = $d');
        _reinitController.sink.add(null);
      });

    //load data
    _initController = new PublishSubject();
    _loadMoreController = new PublishSubject();
    _loadedAllController = new PublishSubject();
    _reinitController = new PublishSubject();
    _refreshRowsController = new PublishSubject();
    _errorController = new PublishSubject();

    Observable<DiyResourceListState> _initObservable = _initController
      .map((p) => false)
      .flatMap(_load)
      .doOnData((d) {
        //print('[INIT] after flatMap data = $d');
      });
    Observable<DiyResourceListState> _loadMoreObservable = _loadMoreController
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 300)))
      .where((p) {
        final bool lastIsLoadedAllVal = _lastIsLoadedAllObservable.value;
        //print('[LOAD FILTER] lastIsLoadedAllVal = $lastIsLoadedAllVal');
        return !lastIsLoadedAllVal;
      })
      .map((p) => false)
      .exhaustMap(_load)
      .doOnData((d) {
        //print('[LOAD MORE] after exhaustMap data = $d');
      });
    Observable<DiyResourceListState> _reinitObservable = _reinitController
      .map((p) => true)//refresh
      .doOnData((d) {
        //print('[BEFORE REINIT] data = $d');
        _offset = 0;
      })
      .flatMap(_load)
      .doOnData((d) {
        //print('[REFRESH] after flatMap data = $d');
      });

    //refresh current list without connect to outsource store(database)
    Observable<DiyResourceListState> _refreshRowsObservable = _refreshRowsController
      .debounce((_) => TimerStream(true, const Duration(milliseconds: 300)))
      .map((inlist) {
        //current state
        final DiyResourceListState lastState = _lastValObservable.value;

        List<DiyResource> nextList = lastState
          .list
          .map((p) {
            DiyResource val = inlist.firstWhere((diy) => diy == p, orElse: () => null);
            return val == null ? p : p.copyWith(inMyPalette: val.inMyPalette);
          })
          .toList();

        DiyResourceListState nextState = lastState.copyWith(list: nextList);
        return nextState;
      })
      .doOnData((d) {
        //print('[REFRESH ROWS] after map data = $d');
      });
    
    _lastIsLoadedAllObservable = _loadedAllController
      .stream
      .doOnData((d) {
        //print('[IS LOADED ALL] data = $d');
      })
      .publishValueSeeded(false);

    //merged
    Observable<Observable<DiyResourceListState>> streams = Observable
      .merge([_initObservable, _loadMoreObservable, _reinitObservable, _refreshRowsObservable])
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
    _lastIsLoadedAllObservable.connect();
  }

  Stream<DiyResourceListState> _load(bool isReinit) async* {
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

      //if loaded all data
      bool isLoadedAll = list.isEmpty || list.length < _limit;
      _loadedAllController.sink.add(isLoadedAll);

      if (lastVal == null || isReinit) {
        state = new DiyResourceListState.initialList(list, isLoadedAll);
      } else {
        List<DiyResource> currentList = lastVal.list;
        currentList.addAll(list);
        state = new DiyResourceListState.initialList(currentList, isLoadedAll);
      }

      _offset += _limit;
    } catch(err) {
      state = new DiyResourceListState(error: err, isLoading: false, isLoadedAll: false, list: null);
    }

    yield state;
  }

  dispose() async {
    await _searchController.close();
    
    await _initController.close();
    await _reinitController.close();
    await _loadMoreController.close();
    await _errorController.close();
  }
}
