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

  //constructor
  Project({
    int projectId,
    String name,
    int beginDate,
    int endDate,
    String note,
    String projectGuid,
  }) {
    this.projectId = projectId;
    this.name = name;
    this.beginDate = beginDate ?? DateTime.now().millisecondsSinceEpoch;
    this.endDate = endDate;
    this.note = note;
    this.projectGuid = projectGuid;
  }

  factory Project.fromMap(Map<String, dynamic> json) => new Project(
      projectId: json["project_id"],
      name: json["name"],
      beginDate: json["begin_date"],//dateFormatter.parse(json["beginDate"]),
      endDate: json["end_date"],//dateFormatter.parse(json["beginDate"]),
      note: json["note"],
      projectGuid: json["project_guid"],
  );

  Map<String, dynamic> toMap() => {
    "project_id": projectId,
    "name": name,
    "begin_date": beginDate,//dateFormatter.format(beginDate),
    "end_date": endDate,//endDate == null ? null : dateFormatter.format(endDate),
    "note": note,
    "project_guid": projectGuid
  };

  bool operator == (o) => o is Project && projectGuid == o.projectGuid;

  int get hashCode => quiver.hash2(projectId.hashCode, projectGuid.hashCode);

  @override
  String toString() {
    return
    """
    (
      projectId: ${this.projectId},
      name: ${this.name},
      beginDate: ${this.beginDate},
      endDate: ${this.endDate},
      note: ${this.note},
      projectGuid: ${this.projectGuid}
    )
    """;
  }
}