import 'dart:convert';

SchemaType schemaTypeFromJson(String str) {
  final jsonData = json.decode(str);
  return SchemaType.fromJson(jsonData);
}

String schemaTypeToJson(SchemaType data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class SchemaType {
  String name;
  String note;
  int schemaTypeId;
  int value;

  SchemaType({
    this.name,
    this.note,
    this.schemaTypeId,
    this.value,
  });

  factory SchemaType.fromJson(Map<String, dynamic> json) => new SchemaType(
    name: json["name"] == null ? null : json["name"],
    note: json["note"] == null ? null : json["note"],
    schemaTypeId: json["schemaTypeId"] == null ? null : json["schemaTypeId"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "note": note == null ? null : note,
    "schemaTypeId": schemaTypeId == null ? null : schemaTypeId,
    "value": value == null ? null : value,
  };
}
