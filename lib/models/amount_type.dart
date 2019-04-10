import 'dart:convert';

AmountType amountTypeFromJson(String str) {
  final jsonData = json.decode(str);
  return AmountType.fromJson(jsonData);
}

String amountTypeToJson(AmountType data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AmountType {
  int amountTypeId;
  String color;
  String name;
  String note;

  AmountType({
    this.amountTypeId,
    this.color,
    this.name,
    this.note,
  });

  factory AmountType.fromJson(Map<String, dynamic> json) => new AmountType(
    amountTypeId: json["amountTypeId"] == null ? null : json["amountTypeId"],
    color: json["color"] == null ? null : json["color"],
    name: json["name"] == null ? null : json["name"],
    note: json["note"] == null ? null : json["note"],
  );

  Map<String, dynamic> toJson() => {
    "amountTypeId": amountTypeId == null ? null : amountTypeId,
    "color": color == null ? null : color,
    "name": name == null ? null : name,
    "note": note == null ? null : note,
  };
}
