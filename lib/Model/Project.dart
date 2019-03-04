// To parse this JSON data, do
// final project = projectFromJson(jsonString);

import 'dart:convert';
//import 'package:intl/intl.dart';


Project projectFromJson(String str) {
    final jsonData = json.decode(str);
    return Project.fromJson(jsonData);
}

String projectToJson(Project data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

//final DateFormat dateFormatter = new DateFormat('yyyy.MM.dd HH:mm:ss');

class Project {
    int projectId;
    String name;
    int beginDate;//UTC
    int endDate;//UTC
    String note;

    Project({
        this.projectId,
        this.name,
        this.beginDate,
        this.endDate,
        this.note,
    });

    factory Project.fromJson(Map<String, dynamic> json) => new Project(
        projectId: json["projectId"],
        name: json["name"],
        beginDate: json["beginDate"],//dateFormatter.parse(json["beginDate"]),
        endDate: json["endDate"],//dateFormatter.parse(json["beginDate"]),
        note: json["note"],
    );


    Map<String, dynamic> toJson() => {
      "projectId": projectId,
      "name": name,
      "beginDate": beginDate,//dateFormatter.format(beginDate),
      "endDate": endDate,//endDate == null ? null : dateFormatter.format(endDate),
      "note": note,
    };
}