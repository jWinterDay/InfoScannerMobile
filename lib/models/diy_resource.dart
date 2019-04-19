import 'dart:convert';
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
  Object error;

  DiyResourceListState extendWith(DiyResourceListState nextState) {
    if (nextState == null) {
      return null;
    }

    this.isLoading = nextState?.isLoading;
    this.error = nextState?.error;

    if (nextState.list == null) {
      return this;
    }
    if (this.list == null) {
      this.list = nextState.list;
    }

    this.list.addAll(nextState.list);

    return this;
  }

  //constructor
  DiyResourceListState({
    @required this.list,
    @required this.isLoading,
    @required this.error,
  });

  factory DiyResourceListState.initial() => DiyResourceListState(
    isLoading: false,
    list: <DiyResource>[],
    error: null,
  );

  @override
  String toString() {
    return
    """
    (
      isLoading: $isLoading,
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
    this.color,
    this.diyResourceId,
    this.hsl,
    this.lab,
    this.name,
    this.no,
    this.inMyPalette
  });

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
    "in_my_palette": no == null ? 0 : Common.boolToInt(no)
  };

  @override
  String toString() {
    return
    """
    (no: $no)
    """;
  }
}
