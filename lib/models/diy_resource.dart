import 'dart:convert';
import 'package:info_scanner_mobile/resources/common.dart';

DiyResource diyResourceFromJson(String str) {
  final jsonData = json.decode(str);
  return DiyResource.fromJson(jsonData);
}

String diyResourceToJson(DiyResource data) {
  final dyn = data.toJson();
  return json.encode(dyn);
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
    (
      diyResourceId: $diyResourceId,
      name: $name,
      no: $no,
      color: $color,
      hsl: $hsl,
      lab: $lab,
      inMyPalette: $inMyPalette
    )
    """;
  }
}
