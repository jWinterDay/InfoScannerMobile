import 'package:rxdart/rxdart.dart';
import 'package:distinct_value_connectable_observable/distinct_value_connectable_observable.dart';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:flutter/foundation.dart';

import 'package:info_scanner_mobile/resources/diy_resource/diy_resource_repository.dart';
import 'package:info_scanner_mobile/models/diy_resource.dart';

/*static MovieDetailBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MovieDetailBlocProvider)
            as MovieDetailBlocProvider)
        .bloc;
}*/


class DiyResourceBloc {
  int _limit = 10;
  int get limit => _limit;
  set limit(limit) => _limit = limit;

  int _offset = 0;
  int get offset => _offset;
  set offset(offset) => _offset = offset;

  final _diyResourceRepository = DiyResourceRepository();
  //final _diyResourceFetcher = PublishSubject<List<DiyResource>>();
  final _diyResourceFetcher = PublishSubject<DiyResourceListState>();

  List<DiyResource> totalList = new List();

  //
  ValueConnectableObservable<DiyResourceListState> _listState;
  StreamSubscription<DiyResourceListState> _streamSubscription;
  Stream<DiyResourceListState> get diyResourceList => _listState;

  PublishSubject<DiyResourceListState> _initController;// = new PublishSubject<DiyResourceListState>();
  PublishSubject<DiyResourceListState> _loadMoreController;// = new PublishSubject<DiyResourceListState>();
  //PublishSubject<List<DiyResource>> resultController;// = PublishSubject<List<DiyResource>>();

  Observable<DiyResourceListState> get initStream => _initController.stream;
  Observable<DiyResourceListState> get loadMoreStream => _loadMoreController.stream;
  //Observable<DiyResourceListState> resultStream;// => resultController.stream;// = Observable.merge([_initController.stream, _loadMoreController.stream]);
  
  //constructor
  DiyResourceBloc() {
    _initController = PublishSubject<DiyResourceListState>();
    _loadMoreController = PublishSubject<DiyResourceListState>();
    
    //resultStream = Observable.concat([initController]);

    //resultStream = Observable.merge([
    //  initStream,//.doOnData((_) => print('[ACTION] load init data')),
    //  loadMoreStream
        //.map((t) => state$.value)
        //.doOnData((data) {
          //filoadMoreStream.shareValue()
        //  print('[ACTION] load more data');
        //})


    //]);

    //initController.stream.listen((data) {
      //print('init controller list data = $data');
      //totalList.addAll(data);
    //});

    //loadMoreController.stream.listen((data) {
      //var m = data.map((dr) => dr.no);
      //print('load more controller list data = $data');
      //totalList.addAll(data);
    //});

    final Observable<Observable<DiyResourceListState>> streams = Observable.merge([
      initStream,
      loadMoreStream,
    ]).map((state) => Observable.just(state));

    //
    _listState = Observable.switchLatest(streams)
        .distinct()
        .doOnData((state) => print('state = $state'))
        .publishValue();// seedValue: PeopleListState.initial());

    _listState.listen((data) {
      print('listen = $data');
    });

    _streamSubscription = _listState.connect();


  }

  Future _synteticDelay() async {
    await Future.delayed(Duration(milliseconds: 2500));
  }

  Future<DiyResourceListState> initData({String filter = ''}) async {
    List<DiyResource> list;
    DiyResourceListState state;// = new DiyResourceListState(list: list, isLoading: true, error: null);

    try {
      _loadMoreController.sink.add(new DiyResourceListState(error: null, isLoading: true, list: null));
      list = await _diyResourceRepository.fetchAllDiyResources(limit: limit, filter: filter);
      state = new DiyResourceListState(list: list, isLoading: false, error: null);
      totalList.addAll(list);
      _initController.sink.add(state);
    } catch(err) {
      _initController.sink.addError(err);
    }
    return state;
  }

  Future<DiyResourceListState> loadMoreResultData({String filter=''}) async {
    List<DiyResource> list;
    DiyResourceListState state;

    offset += limit;

    try {
      _loadMoreController.sink.add(new DiyResourceListState(error: null, isLoading: true, list: totalList));
      await _synteticDelay();
      list = await _diyResourceRepository.fetchAllDiyResources(offset: offset, limit: limit, filter: filter);
      totalList.addAll(list);
      state = new DiyResourceListState(list: totalList, isLoading: false, error: null);
      _loadMoreController.sink.add(state);
    } catch(err) {
      _loadMoreController.sink.addError(err);
    }
    return state;
  }
  //----------------------

  /*Future _synteticDelay() async {
    await Future.delayed(Duration(milliseconds: 2500));
  }

  Future<List<DiyResource>> _fetch({int offset, int limit, String filter = ''}) async {
    return await _diyResourceRepository.fetchAllDiyResources(offset: offset, limit: limit, filter: filter);
  }

  Future<List<DiyResource>> fetchAllDiyResources({int offset, int limit, String filter = '', bool withDelay = false}) async {
    List<DiyResource> diyResourcesList;

    List<Future<List<DiyResource>>> futures = [_fetch(offset: offset, limit: limit, filter: filter)];
    if (withDelay) {
      futures.add(_synteticDelay());
    }

    try {
      List results = await Future.wait(futures);//[_fetch(offset: offset, limit: limit, filter: filter), _synteticDelay()]);
      diyResourcesList = results.first;
      //inSink.add(diyResourcesList);
    } catch(err) {
      //inSink.addError(err);
    }
    return diyResourcesList;
  }*/

  setInMyPalette(int diyResourceId, {bool val, String filter = ''}) async {
    //await _diyResourceRepository.setInMyPalette(diyResourceId, val: val);
    //fetchAllDiyResources(filter: filter);
  }

  dispose() async {
    await _diyResourceFetcher.drain();
    _diyResourceFetcher.close();
  }
}
