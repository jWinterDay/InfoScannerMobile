// To parse this JSON data, do
// final project = projectFromJson(jsonString);

import 'dart:convert';
import 'package:quiver/core.dart' as quiver;
//import 'package:intl/intl.dart';


Project projectFromJson(String str) {
    final jsonData = json.decode(str);
    return Project.fromMap(jsonData);
}

String projectToJson(Project data) {
    final dyn = data.toMap();
    return json.encode(dyn);
}

//final DateFormat dateFormatter = new DateFormat('yyyy.MM.dd HH:mm:ss');

class Project {
  int projectId;
  String name;
  int beginDate;//UTC
  int endDate;//UTC
  String note;
  String projectGuid;
  String deviceGuid;

  //constructor
  Project({
    this.projectId,
    this.name,
    this.beginDate,
    this.endDate,
    this.note,
    this.projectGuid,
    this.deviceGuid,
  });

  factory Project.fromMap(Map<String, dynamic> json) => new Project(
      projectId: json["project_id"],
      name: json["name"],
      beginDate: json["begin_date"],//dateFormatter.parse(json["beginDate"]),
      endDate: json["end_date"],//dateFormatter.parse(json["beginDate"]),
      note: json["note"],
      projectGuid: json["project_guid"],
      deviceGuid: json["device_guid"],
  );

  Map<String, dynamic> toMap() => {
    "project_id": projectId,
    "name": name,
    "begin_date": beginDate,//dateFormatter.format(beginDate),
    "end_date": endDate,//endDate == null ? null : dateFormatter.format(endDate),
    "note": note,
    "project_guid": projectGuid,
    "device_guid": deviceGuid,
  };

  bool operator == (o) => 
    o is Project 
    && projectGuid == o.projectGuid
    && name == o.name
    && deviceGuid == o.deviceGuid;

  int get hashCode => quiver.hash3(projectGuid.hashCode, name.hashCode, deviceGuid.hashCode);

  @override
  String toString() {
    return
    """
    (
      projectId: $projectId,
      name: $name,
      beginDate: $beginDate,
      endDate: $endDate,
      note: $note,
      projectGuid: $projectGuid,
      deviceGuid: $deviceGuid
    )
    """;
  }
}