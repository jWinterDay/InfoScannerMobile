// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_settings_repository.dart';

// **************************************************************************
// InjectorGenerator
// **************************************************************************

class _$SchemaSettingsInjector extends SchemaSettingsInjector {
  void development() {
    final Container container = Container();
    container.registerSingleton((c) => SchemaTuneDbApiProvider.development(),
        name: 'schemaTuneDbApiProvider');
    container.registerSingleton(
        (c) => SchemaCalcMethodDbApiProvider.development(),
        name: 'schemaCalcMethodDbApiProvider');
  }

  void production() {
    final Container container = Container();
    container.registerSingleton((c) => SchemaTuneDbApiProvider(),
        name: 'schemaTuneDbApiProvider');
    container.registerSingleton((c) => SchemaCalcMethodDbApiProvider(),
        name: 'schemaCalcMethodDbApiProvider');
  }
}
