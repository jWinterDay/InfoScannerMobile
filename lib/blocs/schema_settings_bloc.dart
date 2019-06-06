import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:kiwi/kiwi.dart';

import 'package:info_scanner_mobile/resources/schema/schema_settings_repository.dart';
import 'package:info_scanner_mobile/models/schema_settings/schema_tune.dart';
import 'package:info_scanner_mobile/models/schema_settings/schema_size.dart';


class SchemaSettingsBloc {
  SchemaSettingsRepository _schemaSettingsRepository;

  //tune(count)
  PublishSubject<SchemaTuneState> _schemaTuneController;
  ValueConnectableObservable<SchemaTuneState> _schemaTuneValObservable;

  //size
  PublishSubject<SchemaSizeState> _schemaSizeController;
  ValueConnectableObservable<SchemaSizeState> _schemaSizeValObservable;

  //public
  Observable<SchemaTuneState> get schemaTuneState => _schemaTuneController.stream;
  Observable<SchemaSizeState> get schemaSizeState => _schemaSizeController.stream;
  
  //constructor
  SchemaSettingsBloc() {
    //injector
    _schemaSettingsRepository = SchemaSettingsRepository();
    _schemaSettingsRepository.setup();

    //schema tune(count)
    _schemaTuneController = new PublishSubject();
    _schemaTuneValObservable = _schemaTuneController.stream.publishValue();
    _schemaTuneValObservable
      .debounce(Duration(milliseconds: 300))
      .listen((d) {
        //print('[SCHEMA TUNE] value = $d');
        //print('[SCHEMA TUNE]');
      });
    _schemaTuneValObservable.connect();

    //size
    _schemaSizeController = new PublishSubject();
    _schemaSizeValObservable = _schemaSizeController.stream.publishValue();
    _schemaSizeValObservable
      .debounce(Duration(milliseconds: 300))
      .listen((d) {
        print('[SCHEMA SIZE] value = $d');
        //print('[SCHEMA SIZE]');
      });
    _schemaSizeValObservable.connect();
  }

  //schema tune (count list)
  fetchSchemaTuneState() async {
    SchemaTuneState state;

    try {
      List<SchemaTune> countList = await _schemaSettingsRepository.getSchemaTuneList();
      state = new SchemaTuneState.initial(list: countList);
    } catch(err) {
      print(err);
      state = new SchemaTuneState.error(error: err);
    }
    _schemaTuneController.sink.add(state);
  }

  changeCurrentSchemaTuneId(int schemaTuneId) {
    SchemaTuneState lastState = _schemaTuneValObservable.value;

    SchemaTuneState nextState = lastState.copyWith(schemaTuneId: schemaTuneId);
    _schemaTuneController.sink.add(nextState);
  }

  //size
  fetchSchemaSizeState() async {
    SchemaSizeState state;

    /*try {
      List<SchemaTune> countList = await _schemaRepository.getSchemaTuneList();
      state = new SchemaTuneState.initial(list: countList);
    } catch(err) {
      state = new SchemaTuneState.error(error: err);
    }*/
    await Future.delayed(Duration(milliseconds: 0));
    state = new SchemaSizeState(error: null, isLoading: false, sizeParam: SizeParam(height: null, width: null));

    _schemaSizeController.sink.add(state);

    return state;
  }

  changeSize(String width, String height) {
    SchemaSizeState lastState = _schemaSizeValObservable.value;

    SizeParam lastSizeParam = lastState.sizeParam;
    SizeParam nextSizeParam = lastSizeParam.copyWith(width: int.tryParse(width), height: int.tryParse(height));

    SchemaSizeState nextState = lastState.copyWith(sizeParam: nextSizeParam);

    _schemaSizeController.sink.add(nextState);
  }
  
  dispose() async {
    await _schemaTuneController.close();
    await _schemaSizeController.close();
  }
}