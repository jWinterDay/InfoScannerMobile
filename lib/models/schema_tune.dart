import 'dart:convert';
import 'package:flutter/foundation.dart';


class SchemaTuneState {
  List<SchemaTune> list;
  int schemaTuneId;
  bool isLoading;
  Object error;

  //constructor
  SchemaTuneState({
    @required this.list,
    this.schemaTuneId,
    @required this.isLoading,
    @required this.error,
  });

  factory SchemaTuneState.initial({
    List<SchemaTune> list,
    int schemaTuneId,
  }) =>
    SchemaTuneState(
      list: list,
      schemaTuneId: schemaTuneId,
      isLoading: false,
      error: null,
    );

  factory SchemaTuneState.error({
    Object error
  }) =>
    SchemaTuneState(
      list: null,
      schemaTuneId: null,
      isLoading: false,
      error: error,
    );

  SchemaTuneState copyWith({
    List<SchemaTune> list,
    int schemaTuneId,
    bool isLoading,
    Object error,
  }) =>
    SchemaTuneState(
      list: list ?? this.list,
      schemaTuneId: schemaTuneId ?? this.schemaTuneId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );

  factory SchemaTuneState.fromRawJson(String str) => SchemaTuneState.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory SchemaTuneState.fromJson(Map<String, dynamic> json) => new SchemaTuneState(
    list: new List<SchemaTune>.from(json["list"].map((x) => SchemaTune.fromJson(x))),
    schemaTuneId: json["schema_tune_id"],
    isLoading: json["is_loading"],
    error: json["error"],
  );
  Map<String, dynamic> toJson() => {
    "list": new List<dynamic>.from(list.map((x) => x.toJson())),
    "schema_tune_id": schemaTuneId,
    "is_loading": isLoading,
    "error": error,
  };
 
  @override
  String toString() => '(list: $list, schemaTuneId: $schemaTuneId, isLoading: $isLoading, error: $error)';
}

class SchemaTune {
  int schemaTuneId;
  String name;
  String note;
  int value;

  SchemaTune({
    this.name,
    this.note,
    this.schemaTuneId,
    this.value,
  });

  factory SchemaTune.fromRawJson(String str) => SchemaTune.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SchemaTune.fromJson(Map<String, dynamic> json) => new SchemaTune(
    name: json["name"],
    note: json["note"],
    schemaTuneId: json["schema_tune_id"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "note": note,
    "schema_tune_id": schemaTuneId,
    "value": value,
  };

  @override
  String toString() {
    return
    """
    (schemaTuneId: $schemaTuneId, name: $name, note: $note, value: $value)
    """;
  }
}