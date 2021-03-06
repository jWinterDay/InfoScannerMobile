import 'package:info_scanner_mobile/resources/constants.dart';
//import 'package:kiwi/kiwi.dart';

import 'schema_tune_db_api_provider.dart';
import 'schema_calc_method_db_api_provider.dart';

import 'package:info_scanner_mobile/models/schema_settings/schema_tune.dart';
import 'package:info_scanner_mobile/models/schema_settings/schema_calc_method.dart';

//part 'schema_settings_repository.g.dart';


abstract class SchemaSettingsInjector {
  /*@Register.singleton(SchemaTuneDbApiProvider, constructorName: 'development', name: 'schemaTuneDbApiProvider')
  @Register.singleton(SchemaCalcMethodDbApiProvider, constructorName: 'development', name: 'schemaCalcMethodDbApiProvider')
  void development();

  @Register.singleton(SchemaTuneDbApiProvider, name: 'schemaTuneDbApiProvider')
  @Register.singleton(SchemaCalcMethodDbApiProvider, name: 'schemaCalcMethodDbApiProvider')*/
  void production();
}

class SchemaSettingsRepository {
  SchemaSettingsRepository() {
    print('SchemaSettingsRepository constructor');
  }

  void setup() {
    /*_$SchemaSettingsInjector injector = new _$SchemaSettingsInjector();
    
    if (Constants.isProduction) {
      injector.production();
    } else {
      injector.development();
    }*/
  }

  Future<List<SchemaTune>> getSchemaTuneList() {
    return null;
    /*Container container = Container()..silent = true;
    SchemaTuneDbApiProvider schemaTuneDbApiProvider = container<SchemaTuneDbApiProvider>('schemaTuneDbApiProvider');
    return schemaTuneDbApiProvider.getSchemaTuneList();*/
  }

  Future<List<Method>> getSchemaMethodList() {
    return null;
    /*Container container = Container()..silent = true;
    SchemaCalcMethodDbApiProvider schemaCalcMethodDbApiProvider = container<SchemaCalcMethodDbApiProvider>('schemaCalcMethodDbApiProvider');
    return schemaCalcMethodDbApiProvider.getSchemaMethodList();*/
  }

  //SchemaSettingsInjector getSchemaSettingsInjector() => new _$SchemaSettingsInjector();
}