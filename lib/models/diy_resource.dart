import 'dart:convert';
import 'package:quiver/core.dart' as quiver;
import 'package:flutter/foundation.dart';
import 'package:info_scanner_mobile/resources/common.dart';

DiyResource diyResourceFromJson(String str) {
  final jsonData = json.decode(str);
  return DiyResource.fromJson(jsonData);
}

String diyResourceToJson(DiyResource data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class DiyResourceListState {
  List<DiyResource> list;
  bool isLoading;
  bool isLoadedAll;
  Object error;

  //constructor
  DiyResourceListState({
    @required this.list,
    @required this.isLoading,
    @required this.error,
    @required this.isLoadedAll,
  });

  factory DiyResourceListState.initial() => DiyResourceListState(
    isLoading: false,
    isLoadedAll: false,
    list: <DiyResource>[],
    error: null,
  );

  factory DiyResourceListState.initialList(List<DiyResource> list, bool isLoadedAll,) => DiyResourceListState(
    isLoading: false,
    isLoadedAll: isLoadedAll,
    list: list,
    error: null,
  );

  DiyResourceListState copyWith({List<DiyResource> list, bool isLoading, bool isLoadedAll, Object error}) =>
    DiyResourceListState(
      isLoading: isLoading ?? this.isLoading,
      isLoadedAll: isLoadedAll ?? this.isLoadedAll,
      list: list != null ? list : this.list,
      error: error,
    );


  @override
  String toString() {
    return
    """
    (
      isLoading: $isLoading,
      isLoadedAll: $isLoadedAll,
      error: $error,
      list: $list
    )
    """;
  }
}

class DiyResource {
  int diyResourceId;
  String name;
  String no;
  String color;
  String hsl;
  String lab;
  bool inMyPalette;

  DiyResource({
    this.diyResourceId,
    this.name,
    this.no,
    this.color,
    this.hsl,
    this.lab,
    this.inMyPalette
  });

  DiyResource copyWith({int diyResourceId,
                        String name,
                        String no,
                        String color,
                        String hsl,
                        String lab,
                        bool inMyPalette}) =>
    DiyResource(
      diyResourceId: diyResourceId ?? this.diyResourceId,
      name: name ?? this.name,
      no: no ?? this.no,
      color: color ?? this.color,
      hsl: hsl ?? this.hsl,
      lab: lab ?? this.lab,
      inMyPalette: inMyPalette ?? this.inMyPalette
    );

  factory DiyResource.fromJson(Map<String, dynamic> json) => new DiyResource(
    color: json["color"] == null ? null : json["color"],
    diyResourceId: json["diy_resource_id"] == null ? null : json["diy_resource_id"],
    hsl: json["hsl"] == null ? null : json["hsl"],
    lab: json["lab"] == null ? null : json["lab"],
    name: json["name"] == null ? null : json["name"],
    no: json["no"] == null ? null : json["no"],
    inMyPalette: json["in_my_palette"] == null ? false : (json["in_my_palette"] == 1),
  );

  Map<String, dynamic> toJson() => {
    "color": color == null ? null : color,
    "diy_resource_id": diyResourceId == null ? null : diyResourceId,
    "hsl": hsl == null ? null : hsl,
    "lab": lab == null ? null : lab,
    "name": name == null ? null : name,
    "no": no == null ? null : no,
    "in_my_palette": inMyPalette == null ? 0 : Common.boolToInt(inMyPalette)
  };

  bool operator == (o) => 
    o is DiyResource 
    && diyResourceId == o.diyResourceId;
    //&& no == o.no;

  int get hashCode => diyResourceId.hashCode;//quiver.hash2(diyResourceId.hashCode, no.hashCode);

  @override
  String toString() {
    return
    """
    (no: $no, inMyPalette: $inMyPalette)
    """;
  }
}
