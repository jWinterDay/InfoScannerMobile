import 'dart:convert';
import 'package:flutter/foundation.dart';


class SchemaCalcMethodState {
  List<Method> methodList;
  int calcMethodId;
  bool isLoading;
  Object error;

  //constructor
  SchemaCalcMethodState({
    @required this.methodList,
    this.calcMethodId,
    @required this.isLoading,
    @required this.error,
  });

  factory SchemaCalcMethodState.initial({
    List<Method> methodList,
    int calcMethodId,
  }) =>
    SchemaCalcMethodState(
      methodList: methodList,
      calcMethodId: calcMethodId,
      isLoading: false,
      error: null,
    );

  factory SchemaCalcMethodState.error({
    Object error
  }) =>
    SchemaCalcMethodState(
      methodList: null,
      calcMethodId: null,
      isLoading: false,
      error: error,
    );

  SchemaCalcMethodState copyWith({
    List<Method> methodList,
    int calcMethodId,
    bool isLoading,
    Object error,
  }) =>
    SchemaCalcMethodState(
      methodList: methodList ?? this.methodList,
      calcMethodId: calcMethodId ?? this.calcMethodId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );

  factory SchemaCalcMethodState.fromRawJson(String str) => SchemaCalcMethodState.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory SchemaCalcMethodState.fromJson(Map<String, dynamic> json) => new SchemaCalcMethodState(
    methodList: new List<Method>.from(json["method_list"].map((x) => Method.fromJson(x))),
    calcMethodId: json["calc_method_id"],
    error: json["error"],
    isLoading: json["is_loading"],
  );
  Map<String, dynamic> toJson() => {
    "method_list": new List<dynamic>.from(methodList.map((x) => x.toJson())),
    "calc_method_id": calcMethodId,
    "error": error,
    "is_loading": isLoading,
  };

  @override
  String toString() => '(methodList: $methodList, calcMethodId: $calcMethodId, isLoading: $isLoading, error: $error)';
}

class Method {
  int methodId;
  String name;
  List<Param> paramList;

  Method({
    this.methodId,
    this.name,
    this.paramList,
  });

  factory Method.fromRawJson(String str) => Method.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Method.fromJson(Map<String, dynamic> json) => new Method(
    methodId: json["method_id"],
    name: json["name"],
    paramList: new List<Param>.from(json["param_list"].map((x) => Param.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "method_id": methodId,
    "name": name,
    "param_list": paramList
  };

  @override
  String toString() => '(methodId: $methodId, name: $name, paramList: $paramList)';
}

class Param {
  int paramId;
  String name;
  int value;
  String hint;

  //contructor
  Param({
    this.paramId,
    this.name,
    this.value,
    this.hint,
  });

  Param copyWith({
    int paramId,
    String name,
    int value,
    String hint,
  }) =>
    Param(
      paramId: paramId ?? this.paramId,
      name: name ?? this.name,
      value: value ?? this.value,
      hint: hint ?? this.hint,
    );

  factory Param.fromRawJson(String str) => Param.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory Param.fromJson(Map<String, dynamic> json) => new Param(
    paramId: json["param_id"],
    name: json["name"],
    value: json["value"] == null ? null : json["value"],
    hint: json["hint"] == null ? '' : json["hint"],
  );
  Map<String, dynamic> toJson() => {
    "param_id": paramId,
    "name": name,
    "value": value,
    "hint": hint,
  };

  @override
  String toString() => '(paramId: $paramId, name: $name, value: $value)';
}
