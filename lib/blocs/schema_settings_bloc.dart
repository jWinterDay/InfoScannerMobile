import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:info_scanner_mobile/resources/schema/schema_settings_repository.dart';
import 'package:info_scanner_mobile/models/schema_settings.dart';
import 'package:info_scanner_mobile/models/schema_tune.dart';
import 'package:info_scanner_mobile/models/schema_calc_method.dart';



class SchemaSettingsBloc {
  final SchemaRepository _schemaRepository = SchemaRepository();

  //tune(count)
  PublishSubject<SchemaTuneState> _schemaTuneController;
  ValueConnectableObservable<SchemaTuneState> _schemaTuneValObservable;

  //calc method
  PublishSubject<SchemaCalcMethodState> _schemaCalcMethodController;
  ValueConnectableObservable<SchemaCalcMethodState> _schemaCalcMethodValObservable;

  //public
  Observable<SchemaTuneState> get schemaTuneState => _schemaTuneController.stream;
  Observable<SchemaCalcMethodState> get schemaCalcMethodState => _schemaCalcMethodController.stream;
  
  //constructor
  SchemaSettingsBloc() {
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

    _schemaCalcMethodController = new PublishSubject();
    _schemaCalcMethodValObservable = _schemaCalcMethodController.stream.publishValue();
    _schemaCalcMethodValObservable
      .debounce(Duration(milliseconds: 300))
      .listen((d) {
        //print('[SCHEMA CALC METHOD] value = $d');
        //print('[SCHEMA CALC METHOD]');
      });
    _schemaCalcMethodValObservable.connect();
  }

  //schema tune (count list)
  fetchSchemaTuneState() async {
    SchemaTuneState state;

    try {
      List<SchemaTune> countList = await _schemaRepository.getSchemaTuneList();
      state = new SchemaTuneState.initial(list: countList);
    } catch(err) {
      state = new SchemaTuneState.error(error: err);
    }
    _schemaTuneController.sink.add(state);
  }

  changeCurrentSchemaTuneId(int schemaTuneId) {
    SchemaTuneState lastState = _schemaTuneValObservable.value;

    SchemaTuneState nextState = lastState.copyWith(schemaTuneId: schemaTuneId);
    _schemaTuneController.sink.add(nextState);
  }

  //method
  fetchSchemaCalcMethodState() async {
    SchemaCalcMethodState state;

    try {
      List<Method> methodList = await _schemaRepository.getSchemaMethodList();
      state = new SchemaCalcMethodState.initial(methodList: methodList, calcMethodId: null);
    } catch(err) {
      state = new SchemaCalcMethodState.error(error: err);
    }

    _schemaCalcMethodController.sink.add(state);
  }

  changeCurrentCalcMethodId(int calcMethodId) {
    SchemaCalcMethodState lastState = _schemaCalcMethodValObservable.value;

    SchemaCalcMethodState nextState = lastState.copyWith(calcMethodId: calcMethodId);
    _schemaCalcMethodController.sink.add(nextState);
  }

  //param
  changeCalcMethodParam(String val, {int paramId}) {
    SchemaCalcMethodState lastState = _schemaCalcMethodValObservable.value;

    List<Param> params = lastState.methodList
      .singleWhere((method) => method.methodId == lastState.calcMethodId)
      .paramList;

    //params.re

    Param param = params
      .singleWhere((param) => param.paramId == paramId);

    int parsed = int.tryParse(val);

    if (parsed == null) {
      return;
    }

    param.value = parsed;

    _schemaCalcMethodController.sink.add(lastState);
  }

  dispose() async {
    await _schemaTuneController.close();
    await _schemaCalcMethodController.close();
  }
}