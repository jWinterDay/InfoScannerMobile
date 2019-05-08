import 'dart:convert';
import 'package:flutter/foundation.dart';

import './schema_tune.dart';
import './schema_calc_method.dart';


class SchemaSettings {
  bool isLoading;
  Object error;

  ///Count list and current schema's tune id
  SchemaTuneState schemaTuneListState;
  int schemaTuneId;

  ///Calculate methods
  SchemaCalcMethodState schemaCalcMethod;
  int schemaCalcMethodId;

  //constructor
  SchemaSettings({
    this.isLoading,
    this.error,
    @required this.schemaTuneListState,
    this.schemaTuneId,
    @required this.schemaCalcMethod,
    this.schemaCalcMethodId,
  });

  factory SchemaSettings.initial({
    SchemaTuneState schemaTuneListState,
    SchemaCalcMethodState schemaCalcMethod
  }) => SchemaSettings(
      isLoading: false,
      error: null,
      schemaTuneListState: schemaTuneListState,
      schemaCalcMethod: schemaCalcMethod
    );

  factory SchemaSettings.error({
    Object error,
  }) => SchemaSettings(
      isLoading: false,
      error: error,
      schemaTuneListState: null,
      schemaCalcMethod: null
    );

  SchemaSettings copyWith({
    bool isLoading,
    Object error,
    SchemaTuneState schemaTuneListState,
    int schemaTuneId,
    SchemaCalcMethodState schemaCalcMethod,
    int schemaCalcMethodId
  }) =>
    SchemaSettings(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      schemaTuneListState: schemaTuneListState ?? this.schemaTuneListState,
      schemaTuneId: schemaTuneId ?? this.schemaTuneId,
      schemaCalcMethod: schemaCalcMethod ?? this.schemaCalcMethod,
      schemaCalcMethodId: schemaCalcMethodId ?? this.schemaCalcMethodId,
    );

  factory SchemaSettings.fromRawJson(String str) => SchemaSettings.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory SchemaSettings.fromJson(Map<String, dynamic> json) => new SchemaSettings(
    isLoading: json["is_loading"],
    error: json["error"],
    schemaTuneListState: SchemaTuneState.fromJson(json["schema_tune_list_state"]),
    schemaTuneId: json["schema_tune_id"],
    schemaCalcMethod: SchemaCalcMethodState.fromJson(json["schema_calc_method_state"]),
    schemaCalcMethodId: json["schema_calc_method_id"],
  );

  Map<String, dynamic> toJson() => {
    "is_loading": isLoading,
    "error": error,
    "schema_tune_list_state": schemaTuneListState.toJson(),
    "schema_tune_id": schemaTuneId,
    "schema_calc_method": schemaCalcMethod,
    "schema_calc_method_id": schemaCalcMethodId
  };

  @override
  String toString() {
    return
    """
    (isLoading: $isLoading, error: $error,
     schemaTuneListState: $schemaTuneListState, schemaTuneId: $schemaTuneId,
     schemaCalcMethod: $schemaCalcMethod, schemaCalcMethodId: $schemaCalcMethodId
    )
    """;
  }
}